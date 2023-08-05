//
//  Vector.swift
//  
//
//  Created by Carlyn Maw on 8/3/23.
//

import Foundation

//No simd or accelerate for now. Not pumping these in quantity to a screen. 
public struct Vector:Hashable {
    let x:Double
    let y:Double
    let z:Double
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func scaled(by value:Double) -> Vector {
        Vector(x: x*value, y: y*value, z: z*value)
    }
    
    static func random(range:ClosedRange<Double>) -> Self {
        Self(x: .random(in: range), y: .random(in: range), z: .random(in: range))
    }
    
    static func random(x xrange:ClosedRange<Double>, y yrange:ClosedRange<Double>, z zrange:ClosedRange<Double>) -> Self {
        Self(x: .random(in: xrange), y: .random(in: yrange), z: .random(in: zrange))
    }
}
