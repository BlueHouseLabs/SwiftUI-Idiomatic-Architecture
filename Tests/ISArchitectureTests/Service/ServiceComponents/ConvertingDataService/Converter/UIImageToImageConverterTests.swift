//
//  UIImageToImageConverterTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

#if canImport(UIKit)

import SwiftUI
import XCTest
@testable import ISArchitecture

final class UIImageToImageConverterTests: XCTestCase {

    func testConvert() throws {
        
        let uiImage = UIImage(systemName: "pencil")!
        
        let cut = UIImageToImageConverter()
        
        let result = try cut.convert(uiImage)
        
        XCTAssertEqual(result, Image(uiImage: uiImage))
        
    }

}

#endif
