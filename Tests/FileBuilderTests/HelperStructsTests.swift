//
//  MyFirstTest.swift
//  TestingExplorerTests
//
//  Created by Carlyn Maw on 7/18/23.
//

import XCTest
@testable import SketchPad

final class HelperStructsTests: XCTestCase {
    //enum Document.RenderStyle
    func test_minimalTwoStrings() throws {
        let result = Document {
            "Hello, "
            "World!"
        }
        XCTAssertEqual(result.render(style: .minimal), "Hello, World!")
    }
    
    func test_mliTwoStrings() throws {
        let result = Document {
            "Hello, "
            "World!"
        }
        XCTAssertEqual(result.render(style: .multilineIndented), "Hello, \nWorld!")
    }
}
