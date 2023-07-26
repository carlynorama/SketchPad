//
//  SpiralShell.swift
//
//
//  Created by Carlyn Maw on 7/25/23.
//

import Foundation

//https://stackoverflow.com/questions/9600801/evenly-distributing-n-points-on-a-sphere
// Actual article: https://arxiv.org/pdf/0912.4540.pdf

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
    //"Top", (low) indices, start at max Y. Spiral is around Y axis
    //TODO: No placement at poles
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
    //"Top", (low) indices, start at max z. Spiral is around Z axis.
    func generatePoints_SOV2(count:Int, radius:Double) -> [Vector] {
        var points:[Vector] = []
        //original code uses numpy's "arrange" (evenly spaced values
        //within a given interval) to create indices.
        for i in 0..<count {
            
            //offset effects packing. See references in blog post.
            //could also fuzz the value here to blur lines since not using arrange.
            let shiftedIndex = Double(i)+0.5
            
            //comparing to generatePoints_SOV1, functionally very similar
            //i.e. get a value based on a percentage thats been mapped to
            //a value between -1 and 1
            //In _SOV1 its treated as the Y, here it will be the Z
            let polar:Double = acos(1 - 2*shiftedIndex/Double(count))
            let azimuthal:Double = goldenAngleThree * shiftedIndex
            
            //As original, z-axis winding
            points.append(Vector(
                x: cos(azimuthal) * sin(polar),
                y: sin(azimuthal) * sin(polar),
                z: cos(polar)
            ).scaled(by: radius))
            
            //If would prefer y-axis instead.
//            points.append(Vector(
//                x: cos(azimuthal) * sin(polar),
//                y: cos(polar),
//                z: sin(azimuthal) * sin(polar)
//            ).scaled(by: radius))
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

