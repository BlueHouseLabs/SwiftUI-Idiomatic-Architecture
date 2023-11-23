//
//  ConvertingDataServiceTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest
@testable import BespokeTesting
@testable import ISArchitectureTestHelpers
@testable import ISArchitecture

final class ConvertingDataServiceTests: XCTestCase {
    
    struct IntToStringConverter: Converter {
        
        let error: Error?
        
        init(error: Error? = nil) {
            self.error = error
        }
        
        public func convert(_ input: Int) throws -> String {
            if let error {
                throw error
            }
            return String(input)
        }
    }
    
    struct StringToIntConverter: Converter {
        
        let error: Error?
        
        init(error: Error? = nil) {
            self.error = error
        }
        
        public func convert(_ input: String) throws -> Int? {
            if let error {
                throw error
            }
            return Int(input)
        }
    }

    func testConvertInAndOut() async throws {
        
        let input = 23
        let expectedString = "23"
        let expectedOutput = 23
        
        let serviceIsCalled = expectation(description: "Service is called.")
        
        let cut = ConvertingDataService(
            inputConverter: IntToStringConverter(),
            service: FakeService<String, String>(getDataHandler: { string in
                XCTAssertEqual(string, expectedString)
                serviceIsCalled.fulfill()
                return string
            }),
            outputConverter: StringToIntConverter()
        )
        
        let result = try await cut.getData(input: input)
        
        XCTAssertEqual(result, expectedOutput)
        
        await fulfillment(of: [serviceIsCalled], timeout: 1.0)
    }
    
    func testConvertInAndOut_InConversionError() async throws {
        
        let input = 23
        
        let cut = ConvertingDataService(
            inputConverter: IntToStringConverter(error: TestError()),
            service: FakeService<String, String>(getDataHandler: { string in
                XCTFail("Service should not be called.")
                return ""
            }),
            outputConverter: StringToIntConverter()
        )
        
        do {
            _ = try await cut.getData(input: input)
            XCTFail("Call should throw")
        } catch {
            guard error is TestError else {
                XCTFail("Incorrect error type")
                return
            }
        }
    }
    
    func testConvertInAndOut_OutConversionError() async throws {
        
        let input = 23
        let expectedString = "23"
        
        let serviceIsCalled = expectation(description: "Service is called.")
        
        let cut = ConvertingDataService(
            inputConverter: IntToStringConverter(),
            service: FakeService<String, String>(getDataHandler: { string in
                XCTAssertEqual(string, expectedString)
                serviceIsCalled.fulfill()
                return string
            }),
            outputConverter: StringToIntConverter(error: TestError())
        )
        
        do {
            _ = try await cut.getData(input: input)
            XCTFail("Call should throw")
        } catch {
            guard error is TestError else {
                XCTFail("Incorrect error type")
                return
            }
        }
        
        await fulfillment(of: [serviceIsCalled], timeout: 1.0)
    }
    
    func testConvertOnlyIn() async throws {
        
        let input = 23
        let expectedString = "23"
        let expectedOutput = "23"
        
        let serviceIsCalled = expectation(description: "Service is called.")
        
        let cut = ConvertingDataService(
            inputConverter: IntToStringConverter(),
            service: FakeService<String, String>(getDataHandler: { string in
                XCTAssertEqual(string, expectedString)
                serviceIsCalled.fulfill()
                return string
            })
        )
        
        let result = try await cut.getData(input: input)
        
        XCTAssertEqual(result, expectedOutput)
        
        await fulfillment(of: [serviceIsCalled], timeout: 1.0)
        
    }
    
    func testConvertOnlyOut() async throws {
        
        let input = "23"
        let expectedString = "23"
        let expectedOutput = 23
        
        let serviceIsCalled = expectation(description: "Service is called.")
        
        let cut = ConvertingDataService(
            service: FakeService<String, String>(getDataHandler: { string in
                XCTAssertEqual(string, expectedString)
                serviceIsCalled.fulfill()
                return string
            }),
            outputConverter: StringToIntConverter()
        )
        
        let result = try await cut.getData(input: input)
        
        XCTAssertEqual(result, expectedOutput)
        
        await fulfillment(of: [serviceIsCalled], timeout: 1.0)
        
    }

}
