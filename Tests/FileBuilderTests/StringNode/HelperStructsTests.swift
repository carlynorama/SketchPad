//
//  MyFirstTest.swift
//  TestingExplorerTests
//
//  Created by Carlyn Maw on 7/18/23.
//

import XCTest
@testable import SketchPad

final class DocumentTests: XCTestCase {
    
    static let tagExample = Tag("apricot", attributes: ["hello":"starshine"]) {
        StringNode(prefix:"pre", content: "welcome", suffix:"suf")
    }
    
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
    
    func test_minimalNestedStringNode() throws {
        let message:StringNode = .content("I have a message")
        let bracketedMessage = StringNode(prefix:"<p>", content: message, suffix:"</p>")
        let oneMoreDown = StringNode(prefix:"<body>", content: bracketedMessage, suffix:"</body>")
        let result = Document {
            message
            oneMoreDown
        }
        XCTAssertEqual(result.render(style: .minimal), "I have a message<body><p>I have a message</p></body>")
        
    }
    
    func test_mliNestedStringNode() throws {
        let message:StringNode = .content("I have a message")
        let bracketedMessage = StringNode(prefix:"<p>", content: message, suffix:"</p>")
        let oneMoreDown = StringNode(prefix:"<body>", content: bracketedMessage, suffix:"</body>")
        let result = Document {
            message
            oneMoreDown
        }
        XCTAssertEqual(result.render(style: .multilineIndented), "I have a message\n<body>\n\t<p>\n\t\tI have a message\n\t</p>\n</body>")
    }
}

final class TagTests: XCTestCase {
    
    static let attributedTag = Tag("apricot", attributes: ["earthsays":"hello", "goodmorning":"starshine"]) {
        StringNode(prefix:"pre", content: "welcome", suffix:"suf")
    }
    
    static let nestedTags = Tag("apple"){ Tag("banana"){ Tag("pineapple"){ "smoothie" }}}
    
    //TODO: dictionaries and XML attributes don't care about order is this the best way to write these tests?
    
    
    //enum Document.RenderStyle
    func test_minimalAttributedTag() throws {
        let document = Document {
            Self.attributedTag
        }
        let result = document.render(style: .minimal)
        let correctA = "<apricot goodmorning='starshine' earthsays='hello'>prewelcomesuf</apricot>"
        let correctB = "<apricot earthsays='hello' goodmorning='starshine'>prewelcomesuf</apricot>"
        XCTAssert(result==correctA || result==correctB, "\(result) does not match \(correctB) or \(correctA) expected.")
    }
    
    func test_mliAttributedTag() throws {
        let document = Document {
            Self.attributedTag
        }
        let result = document.render(style: .multilineIndented)
        let inside = "\n\tpre\n\t\twelcome\n\tsuf\n"
        let correctA = "<apricot goodmorning='starshine' earthsays='hello'>\(inside)</apricot>"
        let correctB = "<apricot earthsays='hello' goodmorning='starshine'>\(inside)</apricot>"
        XCTAssert(result==correctA || result==correctB, "\(result) does not match \(correctB) or \(correctA) expected.")
    }
    
    func test_minimalNestedTags() throws {
        let document = Document {
            Self.nestedTags
        }
        XCTAssertEqual(document.render(style: .minimal), "<apple><banana><pineapple>smoothie</pineapple></banana></apple>")
    }
    
    func test_mliNestedTags() throws {
        let document = Document {
            Self.nestedTags
        }
        XCTAssertEqual(document.render(style: .multilineIndented), "<apple>\n\t<banana>\n\t\t<pineapple>\n\t\t\tsmoothie\n\t\t</pineapple>\n\t</banana>\n</apple>")
    }
}

final class CurlyBracedTests: XCTestCase {

    //TODO: No configuration give me "goodmorning { starshine }"?

    //enum Document.RenderStyle
    func test_hasOpeningCompactBasicContent() throws {
        let toTest = CurlyBraced(opening: "goodmorning", style: .compact, content: { "starshine" })
        
        let expected = "goodmorning{starshine}"
        let document = Document {
            toTest
        }
        let result1 = document.render(style: .multilineIndented)
        let result2 = document.render(style: .minimal)
        XCTAssertEqual(result1, result2)
        XCTAssertEqual(result1, expected)
    }
    
    func test_hasOpeningSemiCompactBasicContent() throws {
        let toTest = CurlyBraced(opening: "goodmorning", style: .semiCompact, content: { "starshine" })
        
        
        let document = Document {
            toTest
        }
        
        let expected1 = "goodmorning {starshine}"
        let result1 = document.render(style: .minimal)
        XCTAssertEqual(result1, expected1)
        
        let expected2 = "goodmorning {\n\tstarshine\n}"
        let result2 = document.render(style: .multilineIndented)
        XCTAssertEqual(result2, expected2)
    }
    
    func test_hasOpeningExpandedBasicContent() throws {
        let toTest = CurlyBraced(opening: "goodmorning", style: .expanded, content: { "starshine" })
        
        
        let document = Document {
            toTest
        }
        
        //TODO: Why did minimal override expanded??
        let expected1 = "goodmorning{starshine}"
        let result1 = document.render(style: .minimal)
        XCTAssertEqual(result1, expected1)
        
        let expected2 = "goodmorning\n{\n\tstarshine\n}"
        let result2 = document.render(style: .multilineIndented)
        XCTAssertEqual(result2, expected2)
    }
    
    //MARK: No opening
    
    func test_noOpeningCompactBasicContent() throws {
        let toTest = CurlyBraced(style: .compact, content: { "starshine" })
        
        let expected = "{starshine}"
        let document = Document {
            toTest
        }
        let result1 = document.render(style: .multilineIndented)
        let result2 = document.render(style: .minimal)
        XCTAssertEqual(result1, result2)
        XCTAssertEqual(result1, expected)
    }
    
    func test_noOpeningSemiCompactBasicContent() throws {
        let toTest = CurlyBraced(style: .semiCompact, content: { "starshine" })
        
        
        let document = Document {
            toTest
        }
        
        let expected1 = "{starshine}"
        let result1 = document.render(style: .minimal)
        XCTAssertEqual(result1, expected1)
        
        let expected2 = "{\n\tstarshine\n}"
        let result2 = document.render(style: .multilineIndented)
        XCTAssertEqual(result2, expected2)
    }
    
    func test_noOpeningExpandedBasicContent() throws {
        let toTest = CurlyBraced(style: .expanded, content: { "starshine" })
        
        
        let document = Document {
            toTest
        }
        
        //TODO: Why did minimal override expanded??
        let expected1 = "{starshine}"
        let result1 = document.render(style: .minimal)
        XCTAssertEqual(result1, expected1)
        
        let expected2 = "{\n\tstarshine\n}"
        let result2 = document.render(style: .multilineIndented)
        XCTAssertEqual(result2, expected2)
    }
    
    func test_noOpeningCompactNestedContent() throws {
        let toTest = CurlyBraced(style: .compact, content: { "starshine" })
        
        let expected = "{starshine}"
        let document = Document {
            toTest
        }
        let result1 = document.render(style: .multilineIndented)
        let result2 = document.render(style: .minimal)
        XCTAssertEqual(result1, result2)
        XCTAssertEqual(result1, expected)
    }
    
    func test_expandedExpandedNested() throws {
        let inside = CurlyBraced(opening: "goodmorning", style: .expanded, content: { "starshine" })
        let toTest = CurlyBraced(opening: "hello", style: .expanded, content: { inside })
        
        
        let document = Document {
            toTest
        }
        
        let expected1 = "hello{goodmorning{starshine}}"
        let result1 = document.render(style: .minimal)
        XCTAssertEqual(result1, expected1)
        
        let expected2 = "hello\n{\n\tgoodmorning\n\t{\n\t\tstarshine\n\t}\n}"
        let result2 = document.render(style: .multilineIndented)
        XCTAssertEqual(result2, expected2)
    }
    
}

//TODO: Parens Struct, but for now it doesn't differ from CurlyBraced at all. 



