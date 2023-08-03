//
//  File.swift
//  
//
//  Created by Labtanza on 8/3/23.
//

import Foundation


public protocol Geometry:Transformable & Boundable & Surfaceable & Layer & RenderableLayer {
    var id:String { get }
    var shapeName:String { get }
}
