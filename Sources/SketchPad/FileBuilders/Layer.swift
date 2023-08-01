//
//  File.swift
//  
//
//  Created by Carlyn Maw on 8/1/23.
//

import Foundation

//https://talk.objc.io/episodes/S01E225-view-protocols-and-shapes

public protocol Layer {
    associatedtype Content:Layer
    var content: Content { get }
}

public protocol FileBuilder {
    func generateStringForLayer(layer:some Layer) -> String
}

public extension Layer {
    func _render(engine:FileBuilder)  {
        if let bottom = self as? RenderableLayer {
            bottom.render(engine: engine)
        } else {
            content._render(engine: engine)
        }
    }
}

//Indicate a leaf by conforming it to renderable.
public protocol RenderableLayer {
    typealias Content = Never
    func render(engine:FileBuilder)
    
}

public extension Layer where Content == Never {
    var content: Never { fatalError("This should never be called.") }
}

extension Never: Layer {
    public typealias Content = Never
}


@resultBuilder
public enum LayerBuilder {

    public static func buildPartialBlock<L: Layer>(first: L) -> [any Layer] {
        [first]
    }
    
    public static func buildPartialBlock<L0: Layer, L1: Layer>(accumulated: L0, next: L1) -> [any Layer] {
        [L0, L1]
    }
}
