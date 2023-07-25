//
//  Ring.swift
//  
//
//  Created by Carlyn Maw on 7/25/23.
//

import Foundation

public struct Ring {
    public init(count:Int, radius:Double, ratio:Double = 0.1) {
        self.count = count
        self.radius = radius
        self.ratio = ratio
    }
    let count:Int
    let radius:Double
    let ratio:Double

    //TODO: Should be static on Canvas3D
    let tau = Double.pi * 2

    public func buildStage() -> Canvas3D {
        let base_theta = tau/Double(count)
        //let color = 0.5
        let sphere_radius = radius*ratio
        return Canvas3D {
            Sphere(radius: sphere_radius).color(red: 0.18, green: 0.18, blue: 0.18)
             for i in 0..<count {
                 let theta = base_theta * Double(i)
                 let x = cos(theta) * radius
                 let y = sin(theta) * radius
                 
                 Sphere(radius: sphere_radius)
                 .color(
                     red: sin(theta),//theta/tau,
                     green: 0.2, //Double.random(in: 0...1),
                     blue: cos(theta) //tau/theta
                 )
                 //The ranges are all the same in this case.
                 .translateBy(Vector(x: x, y: y, z: 0.0))
             }
        }
    }

}
