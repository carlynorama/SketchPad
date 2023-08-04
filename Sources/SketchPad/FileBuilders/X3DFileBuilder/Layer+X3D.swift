//
//  Layer+X3D.swift
//  
//
//  Created by Carlyn Maw on 8/4/23.
//

import Foundation


protocol _X3DRenderable:_RenderableLayer {
    func renderX3D(context:RenderContext) -> RenderContext
}

extension Layer {
    func _renderX3D(context:RenderContext) -> RenderContext  {
        if let bottom = self as? _X3DRenderable {
            //print("Found a bottom \(id)")
            return bottom.renderX3D(context: context)
        } else {
            //print("Not yet. \(id)")
            return body._renderX3D(context: context)
        }
    }
}

//Must update all the internal _RenderableLayer types
//struct _ArrayLayer<Element:Layer>:Layer, _RenderableLayer
//struct _TupleLayer<First:Layer, Second:Layer>: Layer, _RenderableLayer
//struct _Either<First: Layer, Second: Layer>: Layer, _RenderableLayer


extension _ArrayLayer:_X3DRenderable {
    func renderX3D(context:RenderContext) -> RenderContext {
         var myContext = context
         for element in elements {
             myContext = element._renderX3D(context: myContext)
         }
         return myContext
     }
}

extension _TupleLayer:_X3DRenderable {
    func renderX3D(context:RenderContext) -> RenderContext {
        second._renderX3D(context: first._renderX3D(context: context))
    }
}


extension _Either: _X3DRenderable {
    func renderX3D(context:RenderContext) -> RenderContext {
        switch storage {
        case .first(let storedLayer):
            return storedLayer._renderX3D(context: context)
        case .second(let storedLayer):
            return storedLayer._renderX3D(context: context)
        }
    }
}
