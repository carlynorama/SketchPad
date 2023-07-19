//
//  USDFileBuilderTests.swift
//
//
//  Created by Carlyn Maw on 7/18/23.
//
//
//  MyFirstTest.swift
//  TestingExplorerTests
//
//  Created by Carlyn Maw on 7/18/23.
//

import XCTest
@testable import SketchPad

final class USDFileBuilderTests: XCTestCase {
    
    static let defaultBuilder = USDAFileBuilder()
    
    //This function was changed to use older version of
    //regex so package would be backwards compatible to MacOS 12
    //without if @availables.
    func headerMatch(_ toTest:String) -> Bool {
        
        let pattern = #"#usda 1\.0([^\)]+)\n\)"#
        var result = toTest.range(
            of: pattern,
            options: .regularExpression
        )
        return (result != nil)
    }
    
    //@available(macOS 13.0, *)
    func test_getHeaderStructure() {
        let documentRender = Document {
            Self.defaultBuilder.generateHeader(defaultPrimID: "MyPrim")
        }.render(style: .multilineIndented)
        
        let testResult = headerMatch(documentRender)
        XCTAssert(testResult, "header did not match pattern")
        
        XCTAssert(documentRender.contains("defaultPrim ="), "defaultPrim missing")
        XCTAssert(documentRender.contains("upAxis ="), "upAxis missing")
        XCTAssert(documentRender.contains("metersPerUnit ="), "metersPerUnit missing")
    }
    
    func test_displayColorString() {
        let colorString = Self.defaultBuilder.colorString(shape: Sphere(radius: 3).color(red: 0.1, green: 0.5, blue: 0.6))
        
        let expected = "color3f[] primvars:displayColor = [(0.1, 0.5, 0.6)]"
        
        XCTAssertEqual(colorString, expected)
    }
    
    
    func test_extentString() {
        let extentString = Self.defaultBuilder.extentString(shape: Sphere(radius: 2))
        
        let expected = "float3[] extent = [(-2.0, -2.0, -2.0), (2.0, 2.0, 2.0)]"
        
        XCTAssertEqual(extentString, expected)
    }
    
    
    func test_transfomrString() {
        let transformStringNode = Self.defaultBuilder.transformStringNode(shape: Sphere(radius: 2).translateBy(Vector(x: 3, y: 2, z: 1)))
        
        let expected = StringNode {
            "double3 xformOp:translate = (3.0, 2.0, 1.0)"
            "uniform token[] xformOpOrder = [\"xformOp:translate\"]"
        }
        
        XCTAssertEqual(transformStringNode, expected)
    }

    func test_sphereBuilder() {
        let mySphere = Sphere(id: "MySphere", radius: 5)
            .translateBy(Vector(x: 3, y: 2, z: 1))
            .color(red: 0.1, green: 0.5, blue: 0.6)
        
        let result = Self.defaultBuilder.sphereBuilder(shape: mySphere)
        
        let document = Document {
            result
        }
        
        let expected_min = "def Xform \"MySphere\"{double3 xformOp:translate = (3.0, 2.0, 1.0)uniform token[] xformOpOrder = [\"xformOp:translate\"]def Sphere \"mysphere\"{float3[] extent = [(-5.0, -5.0, -5.0), (5.0, 5.0, 5.0)]color3f[] primvars:displayColor = [(0.1, 0.5, 0.6)]double radius = 5.0}}"
        
        XCTAssertEqual(document.render(style: .minimal), expected_min)
        
        let expected_mli = "def Xform \"MySphere\"\n{\n\tdouble3 xformOp:translate = (3.0, 2.0, 1.0)\n\tuniform token[] xformOpOrder = [\"xformOp:translate\"]\n\tdef Sphere \"mysphere\"\n\t{\n\t\tfloat3[] extent = [(-5.0, -5.0, -5.0), (5.0, 5.0, 5.0)]\n\t\tcolor3f[] primvars:displayColor = [(0.1, 0.5, 0.6)]\n\t\tdouble radius = 5.0\n\t}\n}"
        
        XCTAssertEqual(document.render(style: .multilineIndented), expected_mli)
    }
}

