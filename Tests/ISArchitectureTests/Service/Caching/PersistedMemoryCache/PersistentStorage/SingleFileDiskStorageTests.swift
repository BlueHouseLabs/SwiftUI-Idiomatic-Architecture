//
//  SingleFileDiskStorageTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest

@testable import BespokeTesting
@testable import ISArchitecture
@testable import ISArchitectureTestHelpers

final class SingleFileDiskStorageTests: XCTestCase {

    func testWrite() async throws {
        
        let fileURL = URL(string: "file:///file.txt")!
        
        let input = "Hello World"
        
        let dataWritten = expectation(description: "Data is written")
        
        let cut = SingleFileDiskStorage(
            file: fileURL,
            store: FakeDataStoring(writeAction: { data, toURL in
                XCTAssertEqual(toURL, fileURL)
                XCTAssertEqual(data, input)
                dataWritten.fulfill()
            }, readAction: { _ in
                XCTFail("Data should not be read.")
                return "Unused"
            })
        )
        
        try await cut.write(input)
        
        await fulfillment(of: [dataWritten], timeout: 5.0)
        
    }
    
    func testWrite_Error() async throws {
        
        let fileURL = URL(string: "file:///file.txt")!
        
        let input = "Hello World"
        
        let cut = SingleFileDiskStorage(
            file: fileURL,
            store: FakeDataStoring(writeAction: { _, _ in
                throw TestError()
            }, readAction: { _ in
                XCTFail("Data should not be read.")
                return "Unused"
            })
        )
        
        let exceptionThrown = expectation(description: "Exception is thrown")
        
        do {
            try await cut.write(input)
            XCTFail("Exception should have been thrown")
        } catch {
            exceptionThrown.fulfill()
        }
        
        await fulfillment(of: [exceptionThrown], timeout: 5.0)
        
    }
    
    func testRead() async throws {
        
        let fileURL = URL(string: "file:///file.txt")!
        
        let expected = "Hello World"
        
        let cut = SingleFileDiskStorage(
            file: fileURL,
            store: FakeDataStoring(writeAction: { _, _ in
                XCTFail("Data should not be written.")
            }, readAction: { fromURL in
                XCTAssertEqual(fromURL, fileURL)
                return expected
            })
        )
        
        let result = try await cut.read()
        
        XCTAssertEqual(result, expected)
        
    }
    
    func testRead_Error() async throws {
        
        let fileURL = URL(string: "file:///file.txt")!
        
        let cut = SingleFileDiskStorage(
            file: fileURL,
            store: FakeDataStoring(writeAction: { _, _ in
                XCTFail("Data should not be written.")
            }, readAction: { fromURL in
                throw TestError()
            })
        )
        
        let exceptionThrown = expectation(description: "Exception is thrown")
        
        do {
            _ = try await cut.read()
            XCTFail("Exception should have been thrown")
        } catch {
            exceptionThrown.fulfill()
        }
        
        await fulfillment(of: [exceptionThrown], timeout: 5.0)
        
    }

}
