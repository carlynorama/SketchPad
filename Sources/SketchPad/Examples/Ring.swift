//
//  Ring.swift
//  
//
//  Created by Carlyn Maw on 7/25/23.
//

import Foundation

public struct Ring {
    public init(count:Int, radius:Double) {
        self.count = count
    }
    let count:Int
    let radius:Double

    //TODO: Should be available to Canvas3D
    let tau = Double.pi * 2

    public func buildStage() -> Canvas3D {
        let base_theta = tau/Double(count)
        let color = 0.5
        let sphere_radius = radius/3
        return Canvas3D {
            Sphere(radius: 1.0).color(red: 0.18, green: 0.18, blue: 0.18)
             for i in 0..<count {
                 let theta = base_theta * Double(i)
                 let x = cos(theta)
                 let y = sin(theta)
                 
                 Sphere(radius: sphere_radius)
                 .color(
                     red: color,
                     green: color,
                     blue: color
                 )
                 //The ranges are all the same in this case.
                 .translateBy(Vector(x: x, y: y, z: 0.0))
             }
        }
    }

}
