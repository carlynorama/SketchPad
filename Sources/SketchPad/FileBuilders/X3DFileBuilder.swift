//
//  X3DFileBuilder.swift
//
//
//  Created by Carlyn Maw on 7/12/23.
//

import Foundation

public struct X3DFileBuilder {
    // let title:String
    // let description:String

    public init() { }

    //TODO: fix String builder so if's aren't empty lines
    @MultiLineStringBuilder func generateHeader(
        title:String? = nil, 
        description:String? = nil
        ) -> String {
        #"<?xml version="1.0" encoding="UTF-8"?>"#
        #"<!DOCTYPE X3D PUBLIC "ISO//Web3D//DTD X3D 3.1//EN" "http://www.web3d.org/specifications/x3d-3.1.dtd">"#
        #"<X3D profile="Immersive" version="3.1" xsd:noNamespaceSchemaLocation="http://www.web3d.org/specifications/x3d-3.1.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema-instance">"#
        #"<head>"#
        if let title { "\t<meta content=\"\(title)\" name=\"title\"/>"}
        if let description {"\t<meta content=\"\(description)\" name=\"description\"/>"} 
        "\t\(dateMetaString())"
        "\t<meta content=\"SketchPad\" name=\"generator\"/>"
        "</head>"
    }

    //TODO: Date actually generated
    func dateMetaString() -> String {
        "<meta content=\"13 Jul 2023\" name=\"created\"/>"
    }

    @MultiLineStringBuilder func sceneHeader() -> String {
        "<Scene>"
    }

    @MultiLineStringBuilder func sceneFooter() -> String {
         "</Scene>"
    }

    @MultiLineStringBuilder func pageFooter() -> String {
        "</X3D>"
    }

    func transformStart(transform:Transformation) -> String {
        switch transform {
        case .translate(let v):
        return "<transform translation='\(v.x) \(v.y) \(v.z)'>" 
        // default:
        // fatalError()
        }
    }

    func transformClose() -> String {
        "</transform>"
    }

    func materialString(_ surfaces:[Surface]) -> String {
        //<material DEF="color" diffuseColor=" 0.6 0 0" specularColor='1 1 1'/>
        //<material diffuseColor='0 0 1'></material> 
        if surfaces.count > 1 { fatalError() }
        let surface = surfaces[0]
        switch surface {
            case .displayColor(let c):
                return "<material diffuseColor='\(c.r) \(c.g) \(c.b)'></material>"
            default:
                fatalError()
        }
    }

     @MultiLineStringBuilder func sphereBuilder(shape:Sphere) -> String {
        if !shape.transformations.isEmpty {
            for transform in shape.transformations {
                transformStart(transform:transform)
            }
        }
        "<shape>"
        "\t<appearance>" 
        if !shape.surfaces.isEmpty {
            materialString(shape.surfaces)
        }
        "\t</appearance>" 
        //TODO: what does a unit mean here vs. usd?
        "\t<sphere radius='\(shape.radius)'></sphere>" 
        "</shape>"
        if !shape.transformations.isEmpty {
            for _ in 0..<shape.transformations.count {
                transformClose()
            }
        }
     }

    public func generateStringForStage(stage:Canvas3D) -> String {
        let document = Document {
            generateHeader()
            sceneHeader()
            for item in stage.content {
                sphereBuilder(shape: item)
            }
            sceneFooter()
            pageFooter()
        }
        return document.render(style: .indented)
    }
}

