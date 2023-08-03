//
//  X3DFileBuilder.swift
//
//
//  Created by Carlyn Maw on 7/12/23.
//

import Foundation

public struct X3DFileBuilder {
    static var version = "3.2"
    public init() { }
    
    let TopMatter = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE X3D PUBLIC "ISO//Web3D//DTD X3D \(version)//EN"
                     "http://www.web3d.org/specifications/x3d-\(version).dtd">
    """
    
    let X3DAttributes:Dictionary = [
        "profile":"Immersive", 
        "version":"\(version)", 
        "xmlns:xsd":"http://www.w3.org/2001/XMLSchema-instance", 
        "xsd:noNamespaceSchemaLocation":"http://www.web3d.org/specifications/x3d-\(version).xsd"
    ]
    
    func head(
        title:String? = nil, 
        description:String? = nil
    ) -> StringNodeable {
        
        var metaData = [
            "generator":"SketchPad X3D FileBuilder",
            "created":metaDateString()
        ]
        
        if let title {
            metaData["title"] = title
        }
        if let description {
            metaData["description"] = description
        }
        
        return Tag("head") { metaData.asMetaTags() }
    }
    
    func metaDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYY"
        return formatter.string(from: Date())
    }
    

    
    //TODO: X3D Actually has a color type.
    func materialString(_ surfaces:[Surface]) -> String {
        //<material DEF="color" diffuseColor=" 0.6 0 0" specularColor='1 1 1'/>
        //<material diffuseColor='0 0 1'></material> 
        if surfaces.count > 1 { fatalError() }
        let surface = surfaces[0]
        switch surface {
        case .displayColor(let c):
            return "<Material diffuseColor='\(c.r) \(c.g) \(c.b)'></Material>"
        default:
            fatalError()
        }
    }
    
    func transformAttribute(transform:Transformation) -> Dictionary<String,String> {
        switch transform {
        case .translate(let v):
            return ["translation":"\(v.x) \(v.y) \(v.z)"] 
        }
    }
    
    func sphereBuilder(shape:Sphere) -> StringNodeable {
        var content = Tag("Shape") {
            Tag("Appearance") {
                if !shape.surfaces.isEmpty {
                    materialString(shape.surfaces)
                }
            }
            "<Sphere radius='\(shape.radius)'></Sphere>" 
        }
        
        if !shape.transformations.isEmpty {
            let orderedTransforms = shape.transformations.reversed()
            for item in orderedTransforms {
                let attributes = transformAttribute(transform: item)
                content = Tag("Transform", attributes:attributes) { content }
            }
        } 
        
        return content
    }
    
    public func generateStringForStage(stage:Stage) -> String {
        let document = Document {
            TopMatter
            Tag("X3D", attributes: X3DAttributes) {
                head()
                Tag("Scene") {
                    for item in stage.content {
                        sphereBuilder(shape: item)
                    }
                }
            }
        }
        return document.render(style: .multilineIndented)
    }
}

//Used by generateHeader
fileprivate extension Dictionary<String, String> {
    func asMetaTags() ->
    [String] {
        var tmp:[String] = []
        for (key, value) in self {
            //<meta content="SketchPad" name="generator"/>
            //Don't for get the / in front of the >
            tmp.append("<meta content=\(value.quoted()) name=\(key.quoted())/>")
        }
        return tmp
    }
}
