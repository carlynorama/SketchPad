//
//  SketchPadTests.swift
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

struct Assembly: Layer {
    var content: some Layer {
        Sphere(radius: 15)
    }
}

struct Stage:Layer {
    var content: some Layer {
        Assembly()
        Sphere(radius: 15)
    }
    
}

import XCTest
@testable import SketchPad
//
//final class SketchPadTests: XCTestCase {
//
//    func test_ExampleHelloCanvas() throws {
//        XCTAssertEqual("chuckle".quoted(), "\"chuckle\"")
//    }
//
//}
