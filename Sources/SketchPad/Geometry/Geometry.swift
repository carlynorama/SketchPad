//
//  File.swift
//  
//
//  Created by Labtanza on 8/3/23.
//

import Foundation


protocol Geometry:Transformable & Boundable & Surfaceable & Layer & _RenderableLayer {
    var id:String { get }
    var shapeName:String { get }
}
