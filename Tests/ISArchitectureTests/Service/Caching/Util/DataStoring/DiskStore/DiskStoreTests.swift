//
//  DiskStoreTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest

@testable import BespokeTesting
@testable import ISArchitecture
@testable import ISArchitectureTestHelpers

final class DiskStoreTests: XCTestCase {

    func testWriteThenRead_Success() throws {
        
        let expectedString = "Expected Result"
        
        let expectedURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DiskStoreTests-WriteThenRead-\(Date.now.timeIntervalSince1970).test")
        
        let expectedData = "Data".data(using: .utf8)!
        
        let expectCreateDirectoriesCalled = expectation(description: "createDirectoriesForFile is called")
        
        let cut = DiskStore(
            dataConverter: FakeDataConverter(
                encoder: { input in
                    XCTAssertEqual(input, expectedString)
                    return expectedData
                },
                decoder: { data in
                    XCTAssertEqual(data, expectedData)
                    return expectedString
                }
            ),
            fileManagerFactory: {
                FakeFileManager(
                    createDirectoriesForFileHandler: { file in
                        XCTAssertEqual(file, expectedURL)
                        expectCreateDirectoriesCalled.fulfill()
                    }
                )
            }
        )
        
        XCTAssertNoThrow(try cut.write(expectedString, toURL: expectedURL))
        
        wait(for: [expectCreateDirectoriesCalled], timeout: 1.0)
        
        let result = try cut.read(fromURL: expectedURL)
        
        XCTAssertEqual(result, expectedString)
        
    }
    
    func testWrite_CreateDirectoryFail() throws {
        
        let expectedString = "Expected Result"
        
        let expectedURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DiskStoreTests\(Date.now.timeIntervalSince1970).test")
        
        let expectCreateDirectoriesCalled = expectation(description: "createDirectoriesForFile is called")
        
        let cut = DiskStore(
            dataConverter: FakeDataConverter(
                encoder: { _ in
                    XCTFail("Encoder should not be called")
                    return Data()
                },
                decoder: { _ in
                    XCTFail("Decoder should not be called")
                    return ""
                }
            ),
            fileManagerFactory: {
                FakeFileManager(
                    createDirectoriesForFileHandler: { file in
                        expectCreateDirectoriesCalled.fulfill()
                        XCTAssertEqual(file, expectedURL)
                        throw TestError()
                    }
                )
            }
        )
        
        XCTAssertThrowsError(try cut.write(expectedString, toURL: expectedURL))
        
        wait(for: [expectCreateDirectoriesCalled], timeout: 1.0)
        
    }
    
    func testWrite_EncodeFail() throws {
        
        let expectedString = "Expected Result"
        
        let expectedURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DiskStoreTests\(Date.now.timeIntervalSince1970).test")
        
        let createDirectoriesCalled = expectation(description: "createDirectoriesForFile is called")
        let encoderCalled = expectation(description: "encoder is called")
        
        let cut = DiskStore(
            dataConverter: FakeDataConverter(
                encoder: { _ in
                    encoderCalled.fulfill()
                    throw TestError()
                },
                decoder: { _ in
                    XCTFail("Decoder should not be called")
                    return ""
                }
            ),
            fileManagerFactory: {
                FakeFileManager(
                    createDirectoriesForFileHandler: { file in
                        XCTAssertEqual(file, expectedURL)
                        createDirectoriesCalled.fulfill()
                    }
                )
            }
        )
        
        do {
            try cut.write(expectedString, toURL: expectedURL)
        } catch {
            guard error is TestError else {
                XCTFail("Unexpected error thrown.")
                return
            }
        }
        
        wait(for: [createDirectoriesCalled, encoderCalled], timeout: 1.0, enforceOrder: true)
        
    }
    
    func testRead_DecodeFail() throws {
        
        let existingFileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("DiskStoreTests-Read-\(Date.now.timeIntervalSince1970).test")
        
        let expectedData = "Data".data(using: .utf8)!
        try expectedData.write(to: existingFileURL)
        
        let decoderCalled = expectation(description: "decoder is called")
        
        let cut = DiskStore(
            dataConverter: FakeDataConverter(
                encoder: { _ in
                    XCTFail("Encoder should not be called")
                    return Data()
                },
                decoder: { _ in
                    decoderCalled.fulfill()
                    throw TestError()
                }
            ),
            fileManagerFactory: {
                FakeFileManager(
                    createDirectoriesForFileHandler: { file in
                        XCTFail("createDirectoriesForFile should not be called")
                    }
                )
            }
        )
        
        do {
            _ = try cut.read(fromURL: existingFileURL)
            XCTFail("read should throw")
        } catch {
            guard error is TestError else {
                XCTFail("Unexpected error thrown.")
                return
            }
        }
        
        wait(for: [decoderCalled], timeout: 1.0)
        
        
    }

}
