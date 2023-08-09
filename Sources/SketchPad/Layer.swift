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

protocol _RenderableLayer {
    //    static var renderKey:String { get }
    var id:String { get }
    func render(context:RenderContext) -> RenderContext
    func ids(items:[String]) -> [String]
    
}

extension _RenderableLayer {
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
        if let bottom = self as? _RenderableLayer {
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
    
    //Cannot be -> some Layer return for buildArray to work.
    static func buildPartialBlock<L: Layer>(first: L) -> L {
        first
    }
    
    static func buildPartialBlock<L0: Layer, L1: Layer>(accumulated: L0, next: L1) -> some Layer {
        _TupleLayer(first: accumulated, second: next)
    }
    
    static func buildArray<L:Layer>(_ components: [L]) -> _ArrayLayer<L> {
        _ArrayLayer(from: components)
    }
    
    //Causes error in playground.
    static func buildExpression<L:Layer>(_ expression: L) -> L {
        expression
    }
    
    static func buildExpression<L:Layer>(_ expression: [L]) -> _ArrayLayer<L> {
        _ArrayLayer(from: expression)
    }
    
    static func buildExpression<L:Layer>(_ component: L?) -> _ArrayLayer<L> {
        _ArrayLayer(from: component.map { [$0] } ?? [])
        //TODO: still dirties up the data structure. Anyway around that?
    }
    
    //Seems to work fine.
    //TODO: TBD if need _WrappedLayer might be less confusing when scanning data?
    static func buildOptional<L: Layer>(_ component: L?) -> some Layer {
        _ArrayLayer(from: component.map { [$0] } ?? [])
    }
    
    static func buildEither<First: Layer, Second: Layer>(first component: First) -> _Either<First, Second> {
        _Either<First, Second>(storage: .first(component))
    }
    
    static func buildEither<First: Layer, Second: Layer>(second component: Second) -> _Either<First, Second> {
        _Either<First, Second>(storage: .second(component))
    }
    
    
}

//MARK: Internal "Renderable" Types

struct _ArrayLayer<Element:Layer>:Layer, _RenderableLayer  {
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


struct _TupleLayer<First:Layer, Second:Layer>: Layer, _RenderableLayer {
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


struct _Either<First: Layer, Second: Layer>: Layer, _RenderableLayer {
    enum Storage {
        case first(First)
        case second(Second)
    }
    
    var storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    var id: String {
        switch storage {
        case .first(let storedLayer):
            if let named = storedLayer as? _RenderableLayer {
                return named.id
            }
        case .second(let storedLayer):
            if let named = storedLayer as? _RenderableLayer {
                return named.id
            }
        }
        return "either"
    }
    

    
    func render(context:RenderContext) -> RenderContext {
        switch storage {
        case .first(let storedLayer):
            return storedLayer._render(context: context)
        case .second(let storedLayer):
            return storedLayer._render(context: context)
        }
    }
    
    func ids(items:[String]) -> [String] {
        switch storage {
        case .first(let storedLayer):
            return storedLayer._walk(items: items)
        case .second(let storedLayer):
            return storedLayer._walk(items: items)
        }
    }
    
}

//MARK: Walk

extension Layer {
    public func _walk(items:[String]) -> [String] {
        if let bottom = self as? _RenderableLayer {
            //print("Found a bottom \(id)")
            return bottom.ids(items: items)
        } else {
            //print("Not yet. \(id)")
            return body._walk(items: items)
        }
    }
}

extension _RenderableLayer {
    func ids(items:[String]) -> [String] {
        items + ["\(id)"]
    }
}


// struct AnyLayer : Layer {

//     private let item: any Layer
//     private let type

//     init<L:Layer>(_ item: L) {
//         self.item = item as any Layer
//         self.type = L.Type
//     }

//     // MARK: ItemProtocol
//     var content: some Layer { return item.content as type }
// }