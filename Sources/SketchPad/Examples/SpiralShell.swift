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

    public func buildStage() -> Canvas3D {
        let sun_color = 0.9
        let sphere_radius = radius*ratio
        let points = sphericalPoints2(count: count, radius:radius)
        return Canvas3D {
            Sphere(radius: sphere_radius).color(red: sun_color, green: sun_color, blue: sun_color)
             for point in points {
                 Sphere(radius: sphere_radius)
                 .color(
//                    red: (point.x/radius).magnitude,//theta/tau,
//                    green: (point.y/radius).magnitude, //Double.random(in: 0...1),
//                    blue: (point.z/radius).magnitude //tau/theta
                    red: (point.x/radius).magnitude,//theta/tau,
                    green: (point.y/radius).magnitude, //Double.random(in: 0...1),
                    blue: 0.5//(point.z/radius).magnitude //tau/theta
                 )
                 .translateBy(point)
             }
        }
    }
    
    //Revised from https://stackoverflow.com/a/26127012/5946596
    func generatePoints_SOV1(count:Int, radius:Double) -> [Vector] {
        var points:[Vector] = []
        for i in 0..<count {
            
            //pick a Y value in the domain of the unit circle (-1, 1)
            //based on a percentage of how far into the the count we are
            let sin_theta:Double = 1 - (Double(i) / Double(count - 1)) * 2
            
            //√(c^2 - b^2) = a, in the stack overflow code they call this a radius
            //More specifically its the cos the angle in the plane of y and x,
            //which gives us the radius of the circular slice in the perpendicular plane
            //that x and z will be on.
            let cos_theta = (1.0 - sin_theta * sin_theta).squareRoot()
            
            //Use actual golden angle, in SO answer uses the compliment
            //for a different winding.
            let sphere_phi = goldenAngle * Double(i)
            
            //since we picked Y to be our index axis, what's left is x and z
            //They complement each other (sin,cos pair), but get tilted by the original
            let x = cos(sphere_phi) * cos_theta
            let z = sin(sphere_phi) * cos_theta
            
            //Code could potentially apply the scaling to the points afterwards
            //en masse and in parallel. Not an issue at this point.
            points.append(Vector(x: x, y: sin_theta, z: z).scaled(radius))
        }
        
        return points
    }
    
    

    
    
    func sphericalPoints3(count:Int, radius:Double) -> [Vector] {
        var points:[Vector] = []
        for i in 0...count {
            let phi:Double = acos(1 - 2*Double(i)/Double(count))
            let theta:Double = Double.pi * (1 + (5.0).squareRoot()) * Double(i)
            
            points.append(sphericalCoordinate(theta: phi, phi: theta).scaled(radius))
        }

        return points
    }
    
    //Naive Index
    func sphericalPoints2(count:Int, radius:Double) -> [Vector] {
        var points:[Vector] = []
        for i in 0...count {
            
            let polar_YUP:Double = acos(1 - 2*Double(i)/Double(count))
            
            //Angle of
            let azimuth_YUP:Double = Double.pi * (1 + (5.0).squareRoot()) * Double(i)
            
            points.append(sphericalCoordinate(theta: polar_YUP, phi: azimuth_YUP).scaled(radius))
        }

        return points
    }
    
    //The symbols used here are the same as those used in spherical coordinates. r is constant, while θ varies from 0 to π and φ  varies from 0 to 2π
    //In spherical coordinates, mathematicians usually refer to phi as the polar angle (from the z-axis). The convention in physics is to use phi as the azimuthal angle (from the x-axis).
    //This example is
    //https://en.wikipedia.org/wiki/Spherical_coordinate_system
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
                z: cos(phi)).scaled(radius)
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
