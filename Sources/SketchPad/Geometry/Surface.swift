//
//  File.swift
//  
//
//  Created by Labtanza on 8/3/23.
//

import Foundation







//TODO: Not a fan of this word. Skinnable? Imagable?
public protocol Surfaceable {
    var surfaces:[Surface] { get set }
    //func diffuseColor(red:Double, green:Double, blue:Double) -> Self
    //func emissiveColor(red:Double, green:Double, blue:Double) -> Self
    func color(red:Double, green:Double, blue:Double) -> Self
}
public extension Surfaceable {
    func color(red:Double, green:Double, blue:Double) -> Self {
        var copy = self
        copy.surfaces.append(.displayColor((red, green, blue)))
        return copy
    }
}

public enum Surface {
    case diffuseColor((r:Double, g:Double, b:Double))
    case emissiveColor((r:Double, g:Double, b:Double))
    case metallic(Double)
    case displayColor((r:Double, g:Double, b:Double))
}
