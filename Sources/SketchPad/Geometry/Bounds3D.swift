//
//  File.swift
//  
//
//  Created by Labtanza on 8/3/23.
//

import Foundation

public protocol Boundable {
    var currentBounds:Bounds3D { get }
}

// try to match behavior of
// https://developer.apple.com/documentation/modelio/mdlaxisalignedboundingbox
public struct Bounds3D {
    var minBounds:Vector
    var maxBounds:Vector
}
