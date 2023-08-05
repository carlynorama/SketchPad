//
//  ScratchPad.swift
//  
//
//  Created by Carlyn Maw on 8/5/23.
//

import Foundation



//Test sketch for trying out new infrastructure features.

public struct ScratchPad {
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
