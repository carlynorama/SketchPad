//
//  File.swift
//  
//
//  Created by Carlyn Maw on 7/18/23.
//

import XCTest
@testable import SketchPad

final class StringNodeTests: XCTestCase {
    
    func test_Equatable() {
        XCTAssert(StringNode.content("apples") != StringNode.content("oranges"), "apples was found to equal oranges")
        XCTAssert(StringNode.content("apples") == StringNode.content("apples"), "apples compare")
        
        XCTAssert(StringNode(prefix: "pre", content: "content", suffix: "suff") == StringNode(prefix: "pre", content: "content", suffix: "suff"), "identical containers found not to match")
        
        XCTAssert(StringNode(prefix: "pre", content: "contnet", suffix: "suff") != StringNode(prefix: "pre", content: "content", suffix: "suf"), "non identical containers found to match")
        
        XCTAssert(StringNode(StringNode(prefix: "pre", content: "contnet", suffix: "suff"), "hello".asStringNode) == StringNode(StringNode(prefix: "pre", content: "contnet", suffix: "suff"), "hello".asStringNode), "identical lists found to not match")
        
        XCTAssert(StringNode(StringNode(prefix: "pre", content: "contnet", suffix: "suff"), "hello".asStringNode) != StringNode(StringNode(prefix: "pre", content: "contnet", suffix: "suff"), "goodbye".asStringNode), "nonidentical lists found to match")
    }
    
}
