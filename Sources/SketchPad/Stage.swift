//
//  Stage.swift
//
//
//  Created by Carlyn Maw on 8/2/23.
//


//https://talk.objc.io/episodes/S01E225-view-protocols-and-shapes
//https://talk.objc.io/episodes/S01E343-swiftui-style-backend-library
//https://forums.swift.org/t/swiftui-viewbuilder-result-is-a-tupleview-how-is-apple-using-it-and-able-to-avoid-turning-things-into-anyview/28181
//https://github.com/apple/swift-certificates/blob/8debe3f20df931a29d0e5834fd8101fb49feea42/Sources/X509/Verifier/AnyPolicy.swift#L41



import Foundation


public protocol Layer {
    associatedtype Body:Layer
    var body: Body { get }
}

//Indicate a leaf by conforming it to renderable.

typealias RenderContext = [any StringNodeable]

protocol RenderableLayer {
//    static var renderKey:String { get }
    var id:String { get }
    func render(context:RenderContext) -> RenderContext
    func ids(items:[String]) -> [String]
    
}

extension RenderableLayer {
    public typealias Body = Never
    func render(context:RenderContext) -> RenderContext {
        context + ["\(id)"]
    }
}

extension Layer where Body == Never {
    public var body: Never { fatalError("This should never be called.") }
}

extension Never: Layer {
    var id:String { "Never" }
    public typealias Body = Never
}


extension Layer {
    func _render(context:RenderContext) -> RenderContext  {
        if let bottom = self as? RenderableLayer {
            //print("Found a bottom \(id)")
            return bottom.render(context: context)
        } else {
            //print("Not yet. \(id)")
            return body._render(context: context)
        }
    }
}

@resultBuilder
enum LayerBuilder {

    //Should fix buildArray
    public static func buildPartialBlock<L: Layer>(first: L) -> L {
        first
    }
    
//    public static func buildPartialBlock<L: Layer>(first: L) -> some Layer {
//        first
//    }
    
    public static func buildPartialBlock<L0: Layer, L1: Layer>(accumulated: L0, next: L1) -> some Layer {
        Tuple2Layer(first: accumulated, second: next)
    }
    
    static func buildArray<L:Layer>(_ components: [L]) -> ArrayLayer<L> {
        ArrayLayer(from: components)
    }

//    public static func buildOptional<L: Layer>(_ component: L?) -> some Layer {
//        ArrayLayer(from: component.map { [$0] } ?? [])
//    }
    
   static func buildExpression<L:Layer>(_ component: L?) -> ArrayLayer<L> {
       ArrayLayer(from: component.map { [$0] } ?? [])
   }
    
    
}


struct ArrayLayer<Element:Layer>:Layer, RenderableLayer  {
    var id: String { "ArrayLayer" }

    var elements: [Element]

    public init(from elements:[Element]) {
        self.elements = elements
    }

    func render(context:RenderContext) -> RenderContext {
        var myContext = context
        for element in elements {
            myContext = element._render(context: myContext)
        }
        return myContext
    }
    
    func ids(items:[String]) -> [String] {
        var myItems = items
        for element in elements {
            myItems = element._walk(items: myItems)
        }
        return myItems
    }
}


struct Tuple2Layer<First:Layer, Second:Layer>: Layer, RenderableLayer {
    //static var renderKey: String { "GlueLayer" }
    
    var id:String { "Tuple" }
    var first: First
    var second: Second
    
    init(first:First, second:Second) {
        self.first = first
        self.second = second
    }
    
    func render(context:RenderContext) -> RenderContext {
        second._render(context: first._render(context: context))
    }
    
    func ids(items:[String]) -> [String] {
        second._walk(items: first._walk(items: items))
    }
}

//----------------------------------------------------------------------
//MARK: Group Types

//public struct Stage:Layer {
//    var body:any Layer
//    public init(@LayerBuilder body: () -> some Layer) {
//        self.body = body()
//    }
//
//
//}

struct Stage<Body:Layer>:Layer {
    var body: Body
    public init(@LayerBuilder body: () -> Body) {
        self.body = body()
    }
}

//----------------------------------------------------------------------
//MARK: Walk

extension Layer {
    public func _walk(items:[String]) -> [String] {
        if let bottom = self as? RenderableLayer {
            //print("Found a bottom \(id)")
            return bottom.ids(items: items)
        } else {
            //print("Not yet. \(id)")
            return body._walk(items: items)
        }
    }
}

extension RenderableLayer {
    func ids(items:[String]) -> [String] {
        items + ["\(id)"]
    }
}

//struct IndentedAssembly<Element:Layer>:Layer, RenderableLayer  {
//    var id: String { "Assembly2" }
//
//    var elements: [Element]
//
//    public init(elements:[Element]) {
//        self.elements = elements
//    }
//
//    func render(context:RenderContext) -> RenderContext {
//        print(self)
//        var holding = context
//        for element in elements {
//            holding = element._render(context: holding + ["\n\t"])
//        }
//        return holding
//    }
//}
