//
//  FileManagerDirectoryHelpersTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest
@testable import BespokeTesting
@testable import ISArchitecture

final class FileManagerDirectoryHelpersTests: XCTestCase {

    func testCacheDirectory() throws {
        
        let pathComponents = FileManager.default.cacheDirectory.pathComponents
        XCTAssertEqual(pathComponents[pathComponents.count - 2], "Library")
        XCTAssertEqual(pathComponents[pathComponents.count - 1], "Caches")
        
    }
    
    func testDocumentsDirectory() throws {
        
        let pathComponents = FileManager.default.documentsDirectory.pathComponents
        XCTAssertEqual(pathComponents[pathComponents.count - 1], "Documents")
        
    }
    

}
