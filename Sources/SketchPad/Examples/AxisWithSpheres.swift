//
//  AxisWithSpheres.swift
//
//
//  Created by Carlyn Maw on 7/25/23.
//

import Foundation

public struct AxisWithSpheres {
    public init(count:Int, radius:Double, ratio:Double = 0.1) {
        self.count = count
        self.radius = radius
        self.ratio = ratio
    }
    let count:Int
    let radius:Double
    let ratio:Double
    
    let π = Double.pi
    
    public func buildStage() -> Stage {
        
        let stride = radius/Double(count)
        let sphere_radius = stride * ratio
        print(sphere_radius)
        print(radius)
        
        let r = radius/2
        
        let polar = π/4
        let azimuthal = π/8
        
        return Stage {
            Sphere(radius: sphere_radius*3)
                .color(red: 0.1, green: 0.8, blue: 1)
                .translateBy(sphericalCoordinate(xyPlane: polar, xzPlane: azimuthal).scaled(by: r))
            Sphere(radius: sphere_radius*3)
                .color(red: 1, green: 0.8, blue: 0.1)
                .translateBy(sphericalCoordinate(theta: polar, phi: azimuthal).scaled(by: r))
            
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
    
    //My USD Intuitive
    //Assumptions Y is up, Z is towards the front, X is to the right
    //xyPlane would be the "Polar" plane and xzPlane is the azimuthal
    //Positive angles move the sphere "up" x to y and "forward", x towards z
    func sphericalCoordinate(xyPlane:Double, xzPlane:Double) -> Vector {
        let cos_xz = cos(xzPlane)
        let x = cos_xz * cos(xyPlane)
        let y = cos_xz * sin(xyPlane)
        let z = sin(xzPlane)
        return Vector(x: x, y: y, z: z)
    }
    
    //Classical Physics
    //Z is up, X is towards the front, Y is to the right
    //radial distance: r ≥ 0,
    //polar angle: 0° ≤ θ ≤ 180° (π rad) (also: inclination/elevation)
    //azimuth : 0° ≤ φ < 360° (2π rad).
    //theta == polar, Z is up, positive is from z towards y (left handed/cw when thumb is x)
    //phi == azimuthal, positive is from x towards y (right handed/ccw, when thumb is z)
    func sphericalCoordinate(theta:Double, phi:Double) -> Vector {
        let sin_theta = sin(theta)
        let x = sin_theta * cos(phi)
        let y = sin_theta * sin(phi)
        let z = cos(theta)
        return Vector(x: x, y: y, z: z)
    }
    

}
