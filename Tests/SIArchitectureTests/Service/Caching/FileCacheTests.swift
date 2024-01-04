//
//  FileCacheTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest

@testable import BespokeTesting
@testable import SIArchitectureTestHelpers
@testable import SIArchitecture

final class FileCacheTests: XCTestCase {

    func testValueForKey() async throws {
        
        let key = "Hello World"
        let fileUrl = URL(string: "file:///test.file")!
        
        let expected = "File Content"
        
        let cut = FileCache(
            urlProvider: FakeFileURLProviding(fileURLHandler: { string in
                XCTAssertEqual(string, key)
                return fileUrl
            }),
            fileStorage: FakeDataStoring(
                writeAction: { _, _ in
                    XCTFail("write should not be called")
                },
                readAction: { sourceUrl in
                    XCTAssertEqual(sourceUrl, fileUrl)
                    return expected
                }
            )
        )
        
        let result = try await cut.value(forKey: key)
        
        XCTAssertEqual(result, expected)
        
    }
    
    func testValueForKey_Error() async throws {
        
        let key = "Hello World"
        let fileUrl = URL(string: "file:///test.file")!
        
        let readWasCalled = expectation(description: "read was called")
        
        let cut = FileCache(
            urlProvider: FakeFileURLProviding(fileURLHandler: { string in
                XCTAssertEqual(string, key)
                return fileUrl
            }),
            fileStorage: FakeDataStoring(
                writeAction: { _, _ in
                    XCTFail("write should not be called")
                },
                readAction: { sourceUrl in
                    readWasCalled.fulfill()
                    throw TestError()
                }
            )
        )
        
        do {
            _ = try await cut.value(forKey: key)
            XCTFail("call should throw")
        } catch {
            guard error is TestError else {
                XCTFail("Incorrect error type")
                return
            }
        }
        
        await fulfillment(of: [readWasCalled], timeout: 1.0)
        
    }
    
    func testSetValue() async throws {
        
        let key = "Hello World"
        let fileUrl = URL(string: "file:///test.file")!
        
        let input = "File Content"
        
        let writeWasCalled = expectation(description: "write was called")
        
        let cut = FileCache(
            urlProvider: FakeFileURLProviding(fileURLHandler: { string in
                XCTAssertEqual(string, key)
                return fileUrl
            }),
            fileStorage: FakeDataStoring(
                writeAction: { data, destinationUrl in
                    XCTAssertEqual(destinationUrl, fileUrl)
                    XCTAssertEqual(data, input)
                    writeWasCalled.fulfill()
                },
                readAction: { sourceUrl in
                    XCTFail("write should not be called")
                    return ""
                }
            )
        )
        
        try await cut.setValue(input, forKey: key)
        
        await fulfillment(of: [writeWasCalled], timeout: 1.0)
        
    }
    
    func testSetValue_Error() async throws {
        
        let key = "Hello World"
        let fileUrl = URL(string: "file:///test.file")!
        
        let input = "File Content"
        
        let writeWasCalled = expectation(description: "write was called")
        
        let cut = FileCache(
            urlProvider: FakeFileURLProviding(fileURLHandler: { string in
                XCTAssertEqual(string, key)
                return fileUrl
            }),
            fileStorage: FakeDataStoring(
                writeAction: { data, destinationUrl in
                    XCTAssertEqual(destinationUrl, fileUrl)
                    XCTAssertEqual(data, input)
                    writeWasCalled.fulfill()
                    throw TestError()
                },
                readAction: { sourceUrl in
                    XCTFail("write should not be called")
                    return ""
                }
            )
        )
        
        do {
            try await cut.setValue(input, forKey: key)
            XCTFail("call should throw")
        } catch {
            guard error is TestError else {
                XCTFail("Incorrect error type")
                return
            }
        }
        
        await fulfillment(of: [writeWasCalled], timeout: 1.0)
        
    }

}
