//
//  LatLongSatellites.swift
//  
//
//  Created by Carlyn Maw on 7/26/23.
//

import Foundation

//http://www.songho.ca/opengl/gl_sphere.html
//https://stackoverflow.com/questions/5674149/3d-coordinates-on-a-sphere-to-latitude-and-longitude

public struct LatLongSatellites {
    public init(meridianCount:Int, parallelCount:Int, radius:Double, ratio:Double = 0.1) {
        self.meridianCount = meridianCount
        self.parallelCount = parallelCount
        self.radius = radius
        self.ratio = ratio
    }
    let meridianCount:Int
    let parallelCount:Int
    let radius:Double
    let ratio:Double
    
    let tau = Double.pi * 2
    
    public func buildStage() -> Canvas3D {
        let sun_color = 0.9
        let sphere_radius = radius*ratio
        
        let base_lat_dy = 2.0/Double(parallelCount-1)
        let base_polar_deflection = Double.pi/Double(parallelCount-1)
        let base_long_dphi =  tau/Double(meridianCount)
        
        return Canvas3D {
            Sphere(radius: sphere_radius).color(red: sun_color, green: sun_color, blue: sun_color)
            for i in 0..<parallelCount {
                for j in 0..<meridianCount {
                    Sphere(radius: sphere_radius)
                        .color(
                            red: 0.3, //(Double(j)/Double(meridianCount)),
                            green: 0.3,//(Double(i)/Double(parallelCount)),
                            blue: (Double(i)/Double(parallelCount))
                        )
                        .translateBy(findCoordinate_dtheta(parallel: i, meridian: j))
                }
            }
        }
        
        func findCoordinate_dy(parallel:Int, meridian:Int) -> Vector {
            let polarAngle = asin(1-Double(parallel) * base_lat_dy)
            
            let azimuthal = Double(meridian) * base_long_dphi
            // print("y: \(Double(parallel) * base_lat_dy)")
            // print("polar angle:\(polarAngle), azimuthal:\(azimuthal)")
            let y = sin(polarAngle)
            let x = cos(polarAngle) * cos(azimuthal)
            let z = cos(polarAngle) * sin(azimuthal)
            //print(x, y, z)
            return Vector(x: x, y: y, z: z).scaled(by: radius)
        }
        
        func findCoordinate_dtheta(parallel:Int, meridian:Int) -> Vector {
            let polarAngle = Double.pi / 2 - Double(parallel) * base_polar_deflection
            let azimuthal = Double(meridian) * base_long_dphi
            //print("polar angle:\(polarAngle), azimuthal:\(azimuthal)")
            let y = sin(polarAngle)
            let x = cos(polarAngle) * cos(azimuthal)
            let z = cos(polarAngle) * sin(azimuthal)
            //print(x, y, z)
            return Vector(x: x, y: y, z: z).scaled(by: radius)
        }
        
    }
    
    //MARK: Coordinate conversion. matched set.
    //Assumes Y is up.
    func sphericalCoordinate(to:Vector, from:Vector = Vector(x: 0, y: 0, z: 0)) -> (radius:Double, polar:Double, azimuthal:Double){
        let dx = to.x-from.x
        let dy = to.y-from.y
        let dz = to.z-from.z
        let v_radius = (dx*dx + dy*dy + dz*dz).squareRoot()
        
        let polar = acos(dy/v_radius); //theta
        let azimuthal = atan(dz/dx); //phi
        return (v_radius, polar, azimuthal)
    }

    func cartesianCoordinate(polar:Double, azimuthal:Double, radius:Double = 1) -> Vector {
        let sin_polar = sin(polar)
        let x = sin_polar * cos(azimuthal)
        let y = cos(polar)
        let z = sin_polar * sin(azimuthal)
        return Vector(x: x, y: y, z: z).scaled(by: 1)
    }
    
}

