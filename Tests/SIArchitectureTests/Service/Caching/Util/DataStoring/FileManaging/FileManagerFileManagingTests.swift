//
//  FileManagerFileManagingTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest

final class FileManagerFileManagingTests: XCTestCase {

    func testCreateDirectoriesForFile() throws {
        
        let fm = FileManager.default
        let testDirectory1 = fm.cacheDirectory.appendingPathComponent("Test1", isDirectory: true)
        let testDirectory2 = testDirectory1.appendingPathComponent("Test2", isDirectory: true)
        let testFile1 = testDirectory2.appendingPathComponent("Hello", isDirectory: false)
        let testFile2 = testDirectory2.appendingPathComponent("World", isDirectory: false)
        
        XCTAssertFalse(fm.fileExists(atPath: testDirectory1.path))
        XCTAssertFalse(fm.fileExists(atPath: testDirectory2.path))
        
        XCTAssertFalse(fm.fileExists(atPath: testFile1.path))
        XCTAssertFalse(fm.fileExists(atPath: testFile2.path))
        
        try fm.createDirectoriesForFile(url: testFile1)
        try fm.createDirectoriesForFile(url: testFile2)
        
        XCTAssertTrue(fm.fileExists(atPath: testDirectory1.path))
        XCTAssertTrue(fm.fileExists(atPath: testDirectory2.path))
        
        // Didn't actually create the files, just the directories
        XCTAssertFalse(fm.fileExists(atPath: testFile1.path))
        XCTAssertFalse(fm.fileExists(atPath: testFile2.path))
        
        try fm.removeItem(at: testDirectory2)
        try fm.removeItem(at: testDirectory1)
        
        // Make sure we've cleaned-up
        XCTAssertFalse(fm.fileExists(atPath: testDirectory1.path))
        XCTAssertFalse(fm.fileExists(atPath: testDirectory2.path))
        
    }

}
