//
//  USDAFileBuilder.swift
//
//
//  Created by Carlyn Maw on 7/11/23.
//

import Foundation

public struct USDAFileBuilder {
    //var stage:Canvas3D
    var defaultPrimIndex:Int
    let metersPerUnit:Int
    let upAxis:String
    let documentationNote:String?
    
    public init(defaultPrimIndex: Int = 0,
                metersPerUnit: Int = 1,
                upAxis: String = "Y",
                docNote:String? = nil) {
        //self.stage = stage
        self.defaultPrimIndex = defaultPrimIndex
        self.metersPerUnit = metersPerUnit
        self.upAxis = upAxis
        self.documentationNote = docNote
    }
    
    func generateHeader(defaultPrimID:String,
                        fileType:String = "usda",
                        version:String = "1.0") -> StringNodeable {
        var metaData = [
            "defaultPrim":defaultPrimID.quoted(),
            "metersPerUnit":"\(metersPerUnit)",
            "upAxis":upAxis.quoted()
        ]
        if let documentationNote {
            metaData["documentationNote"] = documentationNote
        }
        return Parens(opening: "#\(fileType) \(version)", 
                      style: .expanded,
                      content: {  metaData.equalSigns() }
        )
    }
    

    
    
    func colorString(_ red:Double, _ green:Double, _ blue:Double) -> String {
        "color3f[] primvars:displayColor = [(\(red), \(green), \(blue))]"
    }
    
    func colorString(shape:any Geometry) -> String {
        //There has been a problem.
        if shape.surfaces.count != 1 { fatalError() }
        let color = shape.surfaces[0]
        switch color {
        case .displayColor(let c):
            return "\(colorString(c.r, c.g, c.b))"
        default:
            fatalError()
        }
    }
    
    
    func  radiusString(_ radius:Double) -> String {
        "double radius = \(radius)"
    }
    
    func extentString(shape:any Geometry) -> String {
        let min = shape.currentBounds.minBounds
        let max = shape.currentBounds.maxBounds
        return "float3[] extent = [(\(min.x), \(min.y), \(min.z)), (\(max.x), \(max.y), \(max.z))]"
    }
    
    
    //TODO: Right now, can do the one and only one transform
    //Will need to consolidate? Should consolidate
    func transformStringNode(shape:any Geometry) -> StringNode {
        if shape.transformations.count != 1 { return .content("") }
        let translate = shape.transformations[0]
        switch translate {
        case .translate(let v):
            return StringNode {
                "double3 xformOp:translate = (\(v.x), \(v.y), \(v.z))"
                "uniform token[] xformOpOrder = [\"xformOp:translate\"]"
            }
        }
    }
    
    func sphereBuilder(shape:Sphere) -> StringNodeable {
        CurlyBraced(opening: "def Xform \"\(shape.id)\"", style: .expanded) {
            
            if !shape.transformations.isEmpty {
                transformStringNode(shape:shape)
            }
            CurlyBraced(opening: "def \(shape.shapeName) \"\(shape.id.lowercased())\"",
                        style: .expanded) {
                "\(extentString(shape: shape))"
                //TODO: How to handle surfaces more generally
                if !shape.surfaces.isEmpty {
                    colorString(shape:shape)
                }
                //This is what makes it a SPHERE builder.
                "\(radiusString(shape.radius))"
            }
        }
    }
    
    public func generateStringForStage(stage:Canvas3D) -> String {
        let document = Document {
            generateHeader(defaultPrimID:stage.content[defaultPrimIndex].id)
            for item in stage.content {
                sphereBuilder(shape: item)
            }
        }
        return document.render(style: .multilineIndented)
    }
    
    public func generateStringForStage(stage:some Layer) -> String {
        stage._render(context: "")
    }
    
}

//used by generateHeader
fileprivate extension Dictionary<String, String> {
    func equalSigns() ->
    [String] {
        var tmp:[String] = []
        for (key, value) in self {
            tmp.append("\(key) = \(value)")
        }
        //Return in alphabetical order?
        //return tmp.sorted()
        return tmp
    }
}
