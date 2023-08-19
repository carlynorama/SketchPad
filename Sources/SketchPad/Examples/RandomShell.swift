//
//  RandomShell.swift
//  
//
//  Created by Carlyn Maw on 7/25/23.
//

import Foundation

//https://en.wikipedia.org/wiki/Sphere

public struct RandomShell {
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
    let π = Double.pi

    //public func buildStage() -> Stage {
    public func buildStage() -> some Layer {
        let sun_color = 0.9
        let sphere_radius = radius*ratio
        return Stage {
            Sphere(radius: sphere_radius).color(red: sun_color, green: sun_color, blue: sun_color)
             //for _ in 0..<count { <- Lies. Not a loop. A closure with an implicit return. 
            IndexedLoop(count: count) { _ in
                 let theta = Double.random(in: 0...π)
                 let phi = Double.random(in: 0...tau)
                 let x = radius * sin(theta) * cos(phi)
                 let y = radius * sin(theta) * sin(phi)
                 let z = radius * cos(theta)
                 
                 Sphere(radius: sphere_radius)
                 .color(
                    red: cos(phi).magnitude,//theta/tau,
                     green: cos(theta).magnitude, //Double.random(in: 0...1),
                    blue: sin(phi).magnitude //tau/theta
                 )
                 .translateBy(Vector(x: x, y: y, z: z))
             }
        }
    }
}
