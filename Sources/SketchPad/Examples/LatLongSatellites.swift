//
//  LatLongSatellites.swift
//  
//
//  Created by Carlyn Maw on 7/26/23.
//

import Foundation

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
    
    //public func buildStage() -> Stage {
    public func buildStage() -> some Layer {
        
        let sphere_radius = radius*ratio
        
        let base_lat_dy = 2.0/Double(parallelCount-1)
        let base_polar_deflection = Double.pi/Double(parallelCount-1)
        let base_long_dphi =  tau/Double(meridianCount)
        
        var coordinateSet:Set<Vector> = []
        
        return Stage {
            //for i in 0..<parallelCount {
            IndexedLoop(count: parallelCount) { i in
                //for j in 0..<meridianCount {
                IndexedLoop(count: meridianCount) { j in
                    makeSphere(parallel: i, meridian: j)
                }
            }
        }
        
        func makeSphere(parallel: Int, meridian: Int) -> Sphere? {
            let coords = findCoordinate_dy(parallel: parallel, meridian: meridian)
            let result = coordinateSet.insert(coords)
            if result.inserted {
                return Sphere(radius: sphere_radius)
                    .color(
                        red: 0.3, //(Double(j)/Double(meridianCount)),
                        green: 0.3,//(Double(i)/Double(parallelCount)),
                        blue: (Double(parallel)/Double(parallelCount))
                    )
                    .translateBy(coords)
            }
            
            return nil
        }
    
        //Polar Angle is deflection down, not inflection up.
        //Y is up.
        
        func findCoordinate_dy(parallel:Int, meridian:Int) -> Vector {
            let polarAngle = acos(1-Double(parallel) * base_lat_dy)
            let azimuthal = Double(meridian) * base_long_dphi
            // print("y: \(Double(parallel) * base_lat_dy)")
            // print("polar angle:\(polarAngle), azimuthal:\(azimuthal)")
            let sin_polar = sin(polarAngle)
            let x = sin_polar * cos(azimuthal)
            let y = cos(polarAngle)
            let z = sin_polar * sin(azimuthal)
            //print(x, y, z)
            return Vector(x: x, y: y, z: z).scaled(by: radius)
        }
        
        func findCoordinate_dtheta(parallel:Int, meridian:Int) -> Vector {
            let polarAngle = Double(parallel) * base_polar_deflection
            let azimuthal = Double(meridian) * base_long_dphi
            //print("polar angle:\(polarAngle), azimuthal:\(azimuthal)")
            let sin_polar = sin(polarAngle)
            let x = sin_polar * cos(azimuthal)
            let y = cos(polarAngle)
            let z = sin_polar * sin(azimuthal)
            //print(x, y, z)
            return Vector(x: x, y: y, z: z).scaled(by: radius)
        }
        
    }
    
    //MARK: Coordinate conversion. matched set.
    //Assumes Y is up. Polar coord is deflection down.
    func sphericalCoordinate(to:Vector, from:Vector = Vector(x: 0, y: 0, z: 0)) -> (radius:Double, polar:Double, azimuthal:Double){
        let dx = to.x-from.x
        let dy = to.y-from.y
        let dz = to.z-from.z
        let v_radius = (dx*dx + dy*dy + dz*dz).squareRoot()
        
        let polar = acos(dy/v_radius);
        let azimuthal = atan(dz/dx);
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

