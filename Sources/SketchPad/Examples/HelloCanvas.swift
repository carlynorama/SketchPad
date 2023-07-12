//
//  helloCanvas.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

public struct HelloCanvas {
    public init() {}
    public var stage = Canvas3D {
        Sphere(radius:1).translateBy(Vector(x:3, y: 2, z: 5))
        Sphere(radius:0.5).color(red:0.5, green:0.5, blue:1.0)
    }
}