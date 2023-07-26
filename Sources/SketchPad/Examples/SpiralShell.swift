//
//  SpiralShell.swift
//
//
//  Created by Carlyn Maw on 7/25/23.
//

import Foundation

//https://stackoverflow.com/questions/9600801/evenly-distributing-n-points-on-a-sphere
// Actual article: https://arxiv.org/pdf/0912.4540.pdf

//TODO: Not placement at poles

public struct SpiralShell {
    public init(count:Int, radius:Double, ratio:Double = 0.1) {
        self.count = count
        self.radius = radius
        self.ratio = ratio
    }
    let count:Int
    let radius:Double
    let ratio:Double

    //TODO: Should be static on Canvas3D?
    let tau = Double.pi * 2
    
    let goldenRatio = (1 + (5.0).squareRoot())/2
    //https://en.wikipedia.org/wiki/Golden_angle
    let goldenAngle = Double.pi * (3-(5.0).squareRoot())
    let goldenAngleCompliment = Double.pi * ((5.0).squareRoot() - 1.0)
    let goldenAngleThree =  Double.pi * (1 + (5.0).squareRoot())

    public func buildStage() -> Canvas3D {
        print(goldenAngle, goldenAngleCompliment, goldenAngleThree)
        let sun_color = 0.9
        let sphere_radius = radius*ratio
        let points = generatePoints_SOV2(count: count, radius:radius)
        return Canvas3D {
            Sphere(radius: sphere_radius).color(red: sun_color, green: sun_color, blue: sun_color)
             for point in points {
                 Sphere(radius: sphere_radius)
                 .color(
                    red: (point.x/radius).magnitude,
                    green: (point.y/radius).magnitude,
                    blue: (point.z/radius).magnitude 
                 )
                 .translateBy(point)
             }
        }
    }
    
    //Revised from https://stackoverflow.com/a/26127012/5946596
    func generatePoints_SOV1(count:Int, radius:Double) -> [Vector] {
        var points:[Vector] = []
        for i in 1...count {
            
            //pick a Y value in the domain of the unit circle (-1, 1)
            //based on a percentage of how far into the the count we are
            let sin_polar:Double = 1 - (Double(i) / Double(count - 1)) * 2
            
            //√(c^2 - b^2) = a, in the stack overflow code they call this a radius
            //More specifically its the cos the angle in the plane of y and x,
            //which gives us the radius of the circular slice in the perpendicular plane
            //that x and z will be on.
            let cos_polar = (1.0 - sin_polar * sin_polar).squareRoot()
            
            //Use actual golden angle, the SO answer uses the compliment
            //for a different winding.
            let azimuthal = goldenAngle * Double(i)
            
            //since we picked Y to be our index axis, what's left is x and z
            //They complement each other (sin,cos pair), but get tilted by the original
            let x = cos(azimuthal) * cos_polar
            let z = sin(azimuthal) * cos_polar
            let y = sin_polar //the up is the lonely one.
            
            //Code could potentially apply the scaling to the points afterwards
            //en masse and in parallel. Not an issue at this point.
            points.append(Vector(x: x, y: y, z: z).scaled(by: radius))
        }
        return points
    }
    
    

    
    //Revised from https://stackoverflow.com/a/44164075/5946596
    func generatePoints_SOV2(count:Int, radius:Double) -> [Vector] {
        var points:[Vector] = []
        for i in 1..<count {
            
            //comparing to generatePoints_SOV1
            //let sin_polar:Double = 1 - (Double(i) / Double(count - 1)) * 2
            //let cos_polar = (1.0 - sin_polar * sin_polar).squareRoot()
            //let polar = acos(cos_polar)
            let polar:Double = acos(1 - 2*Double(i)/Double(count))
            
            let azimuthal:Double = goldenAngleThree * Double(i)
            
            points.append(sphericalCoordinate(theta: polar, phi: azimuthal).scaled(by: radius))
        }

        return points
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
    
    
    
    func coolAccident(count:Int, radius:Double) -> [Vector] {
        var points:[Vector] = []
        for i in 0...count {
            let theta:Double = acos(1 - 2*Double(i)/Double(count))
            let phi:Double = Double.pi * (1 + (5.0).squareRoot()) * Double(i)
            
            
            points.append(Vector(
                x:(cos(theta) * sin(phi)),
                y: (sin(theta) * sin(phi)),
                z: cos(phi)).scaled(by: radius)
            )
        }

        return points
    }

}


//    func generateCylindricalPoints(count:Int, radius:Double) -> [Vector] {
//
//        var points:[Vector] = []
//        let phi = Double.pi * ((5.0).squareRoot() - 1.0)  // golden angle in radians
//
//        for i in 0..<count {
//
//            let y:Double = 1 - (Double(i) / Double(count - 1)) * 2  // y goes from 1 to -1
////            let radius = (1.0 - y * y).squareRoot()  // radius at y
//
//            let theta = phi * Double(i)  // golden angle increment
//
//            let x = cos(theta) * radius
//            let z = sin(theta) * radius
//
//            points.append(Vector(x: x, y: y*radius, z: z))
//
//        }
//        return points
//    }

//
////From answer
////https://stackoverflow.com/a/26127012/5946596
//func generateSphericalPoints(count:Int, radius:Double) -> [Vector] {
//
//    var points:[Vector] = []
//    //chose the complimentary to goldenAngle, ~222.5
//    let goldenAngleCompliment = Double.pi * ((5.0).squareRoot() - 1.0)
//
//    for i in 0..<count {
//
//        let y:Double = 1 - (Double(i) / Double(count - 1)) * 2  // y goes from 1 to -1
//        let r = (1.0 - y * y).squareRoot()  // radius at y
//        let theta = goldenAngleCompliment * Double(i)  // golden angle increment
//
//        let x = cos(theta) * r
//        let z = sin(theta) * r
//
//        points.append(Vector(x: x, y: y, z: z).scaled(radius))
//    }
//    return points
//}

// Before comments
//func sphericalPoints2(count:Int, radius:Double) -> [Vector] {
//    var points:[Vector] = []
//    for i in 0...count {
//        let phi:Double = acos(1 - 2*Double(i)/Double(count))
//        let theta:Double = Double.pi * (1 + (5.0).squareRoot()) * Double(i)
//
//        points.append(sphericalCoordinate(theta: theta, phi: phi).scaled(radius))
//    }
//
//    return points
//}
