//
//  Axis.swift
//  
//
//  Created by Carlyn Maw on 7/25/23.
//

public struct Axis {
    public init(count:Int, radius:Double, ratio:Double = 0.1) {
        self.count = count
        self.radius = radius
        self.ratio = ratio
    }
    let count:Int
    let radius:Double
    let ratio:Double
    
    //public func buildStage() -> Stage {
    public func buildStage() -> some Layer {
        
        let stride = radius/Double(count)
        let sphere_radius = stride * ratio
        return Stage {
            for i in 0...count {
                Sphere(radius: sphere_radius)
                    .color(
                        red: 1,
                        green: 0,
                        blue: 0
                    )
                    .translateBy(Vector(x: Double(i)*stride, y: 0, z: 0))
            }
            for i in 0...count {
                Sphere(radius: sphere_radius)
                    .color(
                        red: 0,
                        green: 1,
                        blue: 0
                    )
                    .translateBy(Vector(x: 0, y: Double(i)*stride, z: 0))
            }
            for i in 0...count {
                Sphere(radius: sphere_radius)
                    .color(
                        red: 0,
                        green: 0,
                        blue: 1
                    )
                    .translateBy(Vector(x: 0, y: 0, z: Double(i)*stride))
            }
        }
    }
}
