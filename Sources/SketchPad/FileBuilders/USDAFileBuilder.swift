//
//  USDAFileBuilder.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

import Foundation

public struct USDAFileBuilder {
    var stage:Canvas3D
    var defaultPrimIndex:Int
    let metersPerUnit:Int
    let upAxis:String
    let documentationNote:String?
    
    public init(stage: Canvas3D, defaultPrimIndex: Int = 0, metersPerUnit: Int = 1, upAxis: String = "Y", docNote:String? = nil) {
        self.stage = stage
        self.defaultPrimIndex = defaultPrimIndex
        self.metersPerUnit = metersPerUnit
        self.upAxis = upAxis
        self.documentationNote = docNote
    }
    
    @StringBuilder func generateHeader() -> String {
        "#usda 1.0\n("
        "\tdefaultPrim = \"\(stage.content[defaultPrimIndex].id)\""
        "\tmetersPerUnit = \(metersPerUnit)"
        "\tupAxis = \"\(upAxis)\""
        if let documentationNote {
            "doc = \"\(documentationNote)\""
        }
        ")"
    }
   
    func translateString(_ xoffset:Double, _ yoffset:Double, _ zoffset:Double) -> String {
        return "double3 xformOp:translate = (\(xoffset), \(yoffset), \(zoffset))"
    }

    func opOrderStringTranslateOnly() -> String {
        "uniform token[] xformOpOrder = [\"xformOp:translate\"]"
    }
        
    func colorString(_ red:Double, _ green:Double, _ blue:Double) -> String {
        "color3f[] primvars:displayColor = [(\(red), \(green), \(blue))]"
    }
        
    func  radiusString(_ radius:Double) -> String {
         "double radius = \(radius)"
    }

    func extentString(shape:Geometry) -> String {
        let minBounds = shape.currentBounds.minBounds
        let maxBounds = shape.currentBounds.maxBounds
        return "float3[] extent = [(\(minBounds.x), \(minBounds.y), \(minBounds.z)), (\(maxBounds.x), \(maxBounds.y), \(maxBounds.z))]"
    }

    //TODO: Right now, can do the one and only one transform
    //Will need to consolidate? Should consolidate
    func transformString(shape:Geometry) -> String {
        if shape.transformations.count != 1 { return "" }
        let translate = shape.transformations[0]
        switch translate {
            case .translate(let v):
            return """
            \t\tdouble3 xformOp:translate = (\(v.x), \(v.y), \(v.z))
            \t\tuniform token[] xformOpOrder = [\"xformOp:translate\"]
            """ 
        }

    }

    @StringBuilder func sphereBuilder(shape:Sphere) -> String {
        "def Xform \"\(shape.id)\"\n{"
        //"def Xform \"\(shape.shapeName)_\(shape.id)\"\n{"
        if !shape.transformations.isEmpty {
            transformString(shape:shape) 
        }
        //"\tdef \(shape.shapeName) \"\(shape.shapeName.lowercased())_\(shape.id)\"\n\t{"
        "\tdef \(shape.shapeName) \"\(shape.id.lowercased())\"\n\t{" 
        "\t\t\(extentString(shape: shape))"
        //Add color string
        //This is what makes it a SPHERE builder.
        "\t\t\(radiusString(shape.radius))"
        "\t}"
        "}"
    }

    @StringBuilder public func generateStringFromStage() -> String {
        generateHeader()
        for item in stage.content {
            sphereBuilder(shape: item)
        }
    }
    }

