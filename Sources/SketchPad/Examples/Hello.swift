//
//  HelloCanvas.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

//Original "Stage" name was Canvas3D
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


//Test sketch for trying out new LayerBuilder features
public struct HelloLayers {
    public init() {}
    public func buildStage() -> some Layer {
        let hello = false
        return Stage {
            Sphere(radius:1).translateBy(Vector(x:0, y: 0, z: 0))
            if !hello {
                Sphere(radius:1).translateBy(Vector(x:3, y: 2, z: 5))
                Cube(side: 3).color(red:0.5, green:0.5, blue:1.0)
                //Sphere(radius:0.5).color(red:0.5, green:0.5, blue:1.0)
            }
            if hello {
                Sphere(radius:0.5).color(red:0.5, green:0.5, blue:1.0)
            } else {
                Cube(side: 4).color(red:0.0, green:0.0, blue:1.0).translateBy(Vector(x:-3, y: -2, z: -5))
            }
        }
    }
}
