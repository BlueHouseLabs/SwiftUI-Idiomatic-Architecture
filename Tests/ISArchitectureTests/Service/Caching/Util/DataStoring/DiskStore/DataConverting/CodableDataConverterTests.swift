//
//  CodableDataConverterTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest
@testable import ISArchitecture

final class CodableDataConverterTests: XCTestCase {
    
    struct TestCodable: Codable, Equatable {
        let hello: String
        let world: String
    }
    
    func testEncodeAndDecode() throws {
        
        let input = TestCodable(hello: "Hello", world: "World")
        
        let cut = CodableDataConverter<TestCodable>()
        
        let data = try cut.encode(input)
        
        XCTAssertNotNil(data)
        
        let output = try cut.decode(data: data)
        
        XCTAssertEqual(input, output)
        
    }

}
