//
//  File.swift
//  
//
//  Created by Carlyn Maw on 8/4/23.
//

import Foundation


extension Cube {
    func render(context: RenderContext) -> RenderContext {
        context + ["Cube"]
    }
}

public struct Cube:Geometry {
    
    static var shapeName = "Cube"
    
    public var id:String
    let side:Double
    
    public var shapeName: String {
        Self.shapeName
    }
    
    public init(id:String? = nil, side: Double, transformations:[Transformation] = []) {
        self.id = id ?? IdString.make(prefix: Self.shapeName)
        self.side = side
        self.transformations = transformations
    }
    
    //Boundable
    public var currentBounds: Bounds3D {
        //TODO: Center or bottom right?
        let minVect = Vector(x: 0, y: 0, z: 0)
        let maxVect = Vector(x: side, y: side, z: side)
        return Bounds3D(minBounds: minVect, maxBounds: maxVect)
    }
    
    //Transformable
    public var transformations:[Transformation] = []
    
    
    //Surfaceable
    public var surfaces:[Surface] = []
    
}
