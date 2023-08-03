//
//  Canvas3D_v2.swift
//  
//
//  Created by Carlyn Maw on 8/2/23.
//

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

    public static func buildPartialBlock<L: Layer>(first: L) -> some Layer {
        first
    }
    
    public static func buildPartialBlock<L0: Layer, L1: Layer>(accumulated: L0, next: L1) -> some Layer {
        Tuple2Layer(first: accumulated, second: next)
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
}
//----------------------------------------------------------------------
//MARK: Rendering

//public protocol FileBuilder {
//    func generateStringForLayer(layer:some Layer) -> String
//}
//
//struct MyRenderer:FileBuilder {
//    func generateStringForLayer(layer: some Layer) -> String {
//        "Yup."
//    }
//}


//----------------------------------------------------------------------
//MARK: Group Types

struct Assembly<Body:Layer>:Layer {
    var body: Body
    public init(@LayerBuilder body: () -> Body) {
        self.body = body()
    }
}

struct IndentedAssembly<Element:Layer>:Layer, RenderableLayer  {
    var id: String { "Assembly2" }

    var elements: [Element]

    public init(elements:[Element]) {
        self.elements = elements
    }

    func render(context:RenderContext) -> RenderContext {
        print(self)
        var holding = context
        for element in elements {
            holding = element._render(context: holding + ["\n\t"])
        }
        return holding
    }
}

////----------------------------------------------------------------------
////MARK: Geometries
//protocol Geometry: Layer & RenderableLayer {}
//
//struct Circle:Geometry {
//    var id:String { "Circle" }
//}
//
//struct Square:Geometry {
//    var id:String { "Square" }
//}
//
//struct Trapazoid:Geometry {
//    var id: String { "Trapazoid " }
//}
//
//struct Triangle:Geometry {
//    var id:String { "Triangle" }
////    func render() {
////        print("I am a teapot")
////    }
//}

//----------------------------------------------------------------------
//MARK: Examples


func testNewLayers() {
    //let insert = IndentedAssembly(elements: [Triangle(),Triangle(),Triangle()])


    //let insert = IndentedAssembly {
    //    Triangle()
    //    Triangle()
    //    Triangle()
    //}

    let test = Assembly {
        Sphere(radius: 10)
        Sphere(radius: 10)
        Sphere(radius: 10)
//        Cube()
//        insert
//        Cube()
//        Circle()
    }

    //print(test)
    let result = test._render(context: [])
    print(result)
    
}

