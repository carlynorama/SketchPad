//
//  Sphere+X3D.swift
//  
//
//  Created by Carlyn Maw on 8/4/23.
//

import Foundation


extension Sphere:_X3DRenderable {
    func renderX3D(context: RenderContext) -> RenderContext {
        context + [self.forX3D()]
    }
}

extension Sphere:X3DRenderable {
    func forX3D() -> StringNodeable {
        var content = Tag("Shape") {
            Tag("Appearance") {
                if !self.surfaces.isEmpty {
                    materialString(self.surfaces)
                }
            }
            "<Sphere radius='\(self.radius)'></Sphere>"
        }
        
        if !self.transformations.isEmpty {
            let orderedTransforms = self.transformations.reversed()
            for item in orderedTransforms {
                let attributes = transformAttribute(transform: item)
                content = Tag("Transform", attributes:attributes) { content }
            }
        }
        
        return content
    }
    
}
