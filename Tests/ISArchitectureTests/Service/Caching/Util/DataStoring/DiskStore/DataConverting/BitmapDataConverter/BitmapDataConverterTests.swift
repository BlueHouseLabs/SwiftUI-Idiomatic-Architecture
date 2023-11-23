//
//  BitmapDataConverterTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

#if canImport(UIKit)

import UIKit
import XCTest
@testable import ISArchitectureTestHelpers
@testable import ISArchitecture

final class BitmapDataConverterTests: XCTestCase {

    func testEncode() throws {
        
        let input = UIImage(systemName: "pencil")!
        let expected = "Expected".data(using: .utf8)!
        
        let cut = BitmapDataConverter(
            imageCoder: FakeImageCoder(data: expected)
        )
        
        XCTAssertEqual(try cut.encode(input), expected)
        
    }
    
    func testEncode_Error() throws {
        
        let input = UIImage(systemName: "pencil")!
        
        let cut = BitmapDataConverter(
            imageCoder: FakeImageCoder(data: nil)
        )
        
        XCTAssertThrowsError(try cut.encode(input))
        
    }
    
    func testDecode() throws {
        
        let input = "Input".data(using: .utf8)!
        let expected = UIImage(systemName: "pencil")!
        
        let cut = BitmapDataConverter(
            imageCoder: FakeImageCoder(image: expected)
        )
        
        XCTAssertEqual(try cut.decode(data: input), expected)
        
    }
    
    func testDecode_Error() throws {
        
        let input = "Input".data(using: .utf8)!
        
        let cut = BitmapDataConverter(
            imageCoder: FakeImageCoder(image: nil)
        )
        
        XCTAssertThrowsError(try cut.decode(data: input))
        
    }

}

#endif
