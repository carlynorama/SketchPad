//
//  File.swift
//  
//
//  Created by Labtanza on 8/3/23.
//

import Foundation


public enum Transformation {
    case translate(Vector)
}



public protocol Transformable {
    var transformations:[Transformation] { get set }
    mutating func translateBy(_ vector:Vector) -> Self
}
public extension Transformable {
    func translateBy(_ vector: Vector) -> Self {
        var copy = self
        copy.transformations.append(.translate(vector))
        return copy
    }
}
//extension Transformable {
// func translateTo(x:Double, y:Double, z:Double) {}
// func translateTo(_ vector:Vector) {}
// func translateBy(x:Double, y:Double, z:Double) {}
// func translateBy(_ vector:Vector) {}

// func rotateBy(x:Double, y:Double, z:Double) {}
// func rotateBy(v:Vector) {}

// func scaleBy(_ onDiagonal:Double) {}
// func scaleBy(x:Double, y:Double, z:Double) {}
// func scaleBy(_ vector:Vector) {}
// func scaleTo(x:Double, y:Double, z:Double) {}
//}
