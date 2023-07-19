import XCTest
@testable import SketchPad

final class StringExtensionTests: XCTestCase {
    
    func test_embraced() throws {
        XCTAssertEqual("chuckle".embrace(with: "*"), "*chuckle*")
        XCTAssertEqual("chuckle".embrace(with: "789"), "789chuckle987")
        XCTAssertEqual("chuckle".embrace(with: "789", maintainOrder: true), "789chuckle789")
    }
    
    func test_quoted() throws {
        XCTAssertEqual("chuckle".quoted(), "\"chuckle\"")
    }
    
    
    
}
