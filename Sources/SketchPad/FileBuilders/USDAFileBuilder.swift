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
    
    struct USDHeader:StringNodeable {
        let fileType:String
        let version:String
        
        var prefix: String { "#\(fileType) \(version)\n(" }
        var suffix: String { ")" }
        
        var content: StringNode
        
        init(fileType:String,
             version:String,
             metaData:Dictionary<String,String>) {
            self.fileType = fileType
            self.version = version
            content = .list(StringNode.dictionaryToEqualSigns(dict: metaData))
        }
        
        var asStringNode: StringNode {
            .container((prefix: prefix, content: content, suffix: suffix))
        }
    }
    
    func generateHeader(defaultPrimID:String,
                        fileType:String = "usda",
                        version:String = "1.0") -> StringNode {
        var metaData = [
            "defaultPrim":defaultPrimID.quoted(),
            "metersPerUnit":"\(metersPerUnit)",
            "upAxis":upAxis.quoted()
        ]
        if let documentationNote {
            metaData["documentationNote"] = documentationNote
        }
        let header = USDHeader(fileType: fileType,
                               version: version,
                               metaData: metaData)
        return header.asStringNode
    }
    
    func colorString(_ red:Double, _ green:Double, _ blue:Double) -> String {
        "color3f[] primvars:displayColor = [(\(red), \(green), \(blue))]"
    }
    
    func colorString(shape:Geometry) -> String {
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
    
    func extentString(shape:Geometry) -> String {
        let min = shape.currentBounds.minBounds
        let max = shape.currentBounds.maxBounds
        return "float3[] extent = [(\(min.x), \(min.y), \(min.z)), (\(max.x), \(max.y), \(max.z))]"
    }
    
    
    //TODO: Right now, can do the one and only one transform
    //Will need to consolidate? Should consolidate
    func transformString(shape:Geometry) -> StringNode {
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
        CurlyBraced(opening: "def Xform \"\(shape.id)\"") {
            
            if !shape.transformations.isEmpty {
                transformString(shape:shape)
            }
            CurlyBraced(opening: "def \(shape.shapeName) \"\(shape.id.lowercased())\"") {
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
        return document.render(style: .indented)
    }
}

