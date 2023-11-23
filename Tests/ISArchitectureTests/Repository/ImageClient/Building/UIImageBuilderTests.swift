//
//  UIImageBuilderTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

#if canImport(UIKit)

import UIKit
import XCTest

@testable import BespokeTesting
@testable import ISArchitecture

final class UIImageBuilderTests: XCTestCase {

    func testBuildFromURL() throws {
        
        let cut = UIImageBuilder()
        
        guard
            let url1 = findResource(testDataDirectoryName: "TestData", filename: "Test1.jpg"),
            let url2 = findResource(testDataDirectoryName: "TestData", filename: "Test2.jpg")
        else {
            XCTFail("Test Data Not Found!")
            return
        }
        
        let uiImage1 = try cut.buildFrom(url: url1)
        let uiImage2 = try cut.buildFrom(url: url2)
        let uiImage3 = try cut.buildFrom(url: url1)
        
        XCTAssertEqual(uiImage1.pngData(), uiImage3.pngData())
        XCTAssertNotEqual(uiImage1.pngData(), uiImage2.pngData())
        XCTAssertNotEqual(uiImage3.pngData(), uiImage2.pngData())
        
    }
    
    func testUIImageFromURL_InvalidData() throws {
        
        let cut = UIImageBuilder()
        
        guard
            let url1 = findResource(testDataDirectoryName: "TestData", filename: "Test.txt")
        else {
            XCTFail("Test Data Not Found!")
            return
        }
        
        XCTAssertThrowsError(try cut.buildFrom(url: url1))
        
    }
    
}

extension XCTestCase {
    
    /// `Tests/MyTargetTests/{testDataDirectoryName}/{filename}`
    public func findResource(
        testDataDirectoryName: String,
        filename: String
    ) -> URL? {
        guard let dataDirectory = findUp(filename: testDataDirectoryName) else {
            return nil
        }
        
        let fileURL = dataDirectory.appendingPathComponent(testDataDirectoryName).appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        return fileURL
    }
    
    func findUp(
        filename: String,
        baseURL: URL = URL(fileURLWithPath: #file).deletingLastPathComponent()
    ) -> URL? {
        let fileURL = baseURL.appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return baseURL
        } else {
            return baseURL.pathComponents.count > 1
            ? findUp(filename: filename, baseURL: baseURL.deletingLastPathComponent())
            : nil
        }
    }
    
}

#endif
