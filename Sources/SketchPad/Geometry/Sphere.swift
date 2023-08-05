//
//  File.swift
//  
//
//  Created by Labtanza on 8/3/23.
//

import Foundation



//public struct Sphere:Geometry, Layer, RenderableLayer {
public struct Sphere:Geometry {
    
    static var shapeName = "Sphere"
    
    public var id:String
    let radius:Double
    
    public var shapeName: String {
        Self.shapeName
    }
    
    public init(id:String? = nil, radius: Double, transformations:[Transformation] = []) {
        self.id = id ?? IdString.make(prefix: Self.shapeName)
        self.radius = radius
        self.transformations = transformations
    }
    
    //Boundable
    public var currentBounds: Bounds3D {
        let minVect = Vector(x: -radius, y: -radius, z: -radius)
        let maxVect = Vector(x: radius, y: radius, z: radius)
        return Bounds3D(minBounds: minVect, maxBounds: maxVect)
    }
    
    //Transformable
    public var transformations:[Transformation] = []
    
    
    //Surfaceable
    public var surfaces:[Surface] = []
    
}


// struct Box:Geometry {
//     let side_x:Double
//     let side_y:Double
//     let side_z:Double

//     var transformations:[Transformation]
// }

// struct Cone:Geometry {
//     let base_radius:Double
//     let height:Double

//     var transformations:[Transformation]
// }
