//
//  Cube+USDA.swift
//  
//
//  Created by Carlyn Maw on 8/4/23.
//

import Foundation

extension Cube {
    func render(context: RenderContext) -> RenderContext {
        context + [self.forUSDA()]
    }
}

extension Cube:USDRenderable {
    //TODO: How is the side specified?
//    func  radiusString(_ radius:Double) -> String {
//        "double radius = \(radius)"
//    }
//    
    func forUSDA() -> StringNodeable {
        CurlyBraced(opening: "def Xform \"\(self.id)\"", style: .expanded) {
            
            if !self.transformations.isEmpty {
                transformStringNode(shape:self)
            }
            CurlyBraced(opening: "def \(self.shapeName) \"\(self.id.lowercased())\"",
                        style: .expanded) {
                "\(extentString(shape: self))"
                //TODO: How to handle surfaces more generally
                if !self.surfaces.isEmpty {
                    colorString(shape:self)
                }
                //This is what makes it a SPHERE builder.
                //"\(radiusString(self.side))"
            }
        }
    }
}
