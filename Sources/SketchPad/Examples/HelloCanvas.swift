//
//  HelloCanvas.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

public struct HelloCanvas {
    public init() {}
    //public func buildStage() -> Stage {
    public func buildStage() -> some Layer {
        Stage {
            Sphere(radius:1).translateBy(Vector(x:3, y: 2, z: 5))
            Sphere(radius:0.5).color(red:0.5, green:0.5, blue:1.0)
        }
    }
}


public struct HelloLayers {
    public init() {}
    public func buildStage() -> some Layer {
        Stage {
            Sphere(radius:1).translateBy(Vector(x:3, y: 2, z: 5))
            Sphere(radius:0.5).color(red:0.5, green:0.5, blue:1.0)
        }
    }
}
