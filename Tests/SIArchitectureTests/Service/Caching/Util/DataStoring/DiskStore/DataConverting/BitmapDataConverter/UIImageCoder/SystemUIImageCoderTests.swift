//
//  SystemUIImageCoderTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

#if canImport(UIKit)

import UIKit
import XCTest
@testable import SIArchitecture

final class SystemUIImageCoderTests: XCTestCase {

    func testJpegDataForUIImage() throws {
        
        let input = UIImage(systemName: "pencil")!
        
        let cut = SystemUIImageCoder(jpegQuality: 1.0)
        
        // System API returns Data? if it fails, so as long as it's not nil, we're going to assume it worked.
        XCTAssertNotNil(cut.jpegDataFor(uiImage: input))
        
    }
    
    func testUIImageFromData() throws {
        
        let input = UIImage(systemName: "pencil")!.jpegData(compressionQuality: 0.9)!
        
        let cut = SystemUIImageCoder(jpegQuality: 0.9)
        
        // System API returns UIImage? if it fails, so as long as it's not nil, we're going to assume it worked.
        XCTAssertNotNil(cut.uiImageFrom(data: input))
        
    }

}

#endif
