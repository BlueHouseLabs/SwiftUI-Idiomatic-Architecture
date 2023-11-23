//
//  CachingTaskServiceTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest

@testable import BespokeTesting
@testable import ISArchitecture
@testable import ISArchitectureTestHelpers

final class CachingTaskServiceTests: XCTestCase {
    
    struct CacheMiss: Error {}
    
    func testGetData_CacheHit() async throws {
        
        let input = "My Input"
        
        let expected = 149
        
        let cut = CachingTaskService(
            dataProvider: FakeComponent<String, Int> { input in
                XCTFail("service should not be called")
                return 0
            },
            cache: FakeCache<String, Int>(
                valueHandler: { key in
                    XCTAssertEqual(key, input)
                    return expected
                },
                setValueHandler: { value, key in
                    XCTFail("setValue should not be called")
                }
            )
        )
        
        let result = try await cut.getData(input: input)
        
        XCTAssertEqual(result, expected)
        
    }
    
    func testGetData_CacheMiss_ServiceSuccess() async throws {
        
        let input = "My Input"
        
        let expected = 149
        
        let cacheQuery = expectation(description: "Cache is checked")
        let serviceCalled = expectation(description: "Service is called")
        let cacheSet = expectation(description: "Cache is set")
        
        let cut = CachingTaskService(
            dataProvider: FakeComponent<String, Int> { parameter in
                XCTAssertEqual(parameter, input)
                serviceCalled.fulfill()
                return expected
            },
            cache: FakeCache<String, Int>(
                valueHandler: { key in
                    XCTAssertEqual(key, input)
                    cacheQuery.fulfill()
                    // Cache throws an exception on miss
                    throw CacheMiss()
                },
                setValueHandler: { value, key in
                    XCTAssertEqual(value, expected)
                    XCTAssertEqual(key, input)
                    cacheSet.fulfill()
                }
            )
        )
        
        let result = try await cut.getData(input: input)
        
        XCTAssertEqual(result, expected)
        
        await fulfillment(of: [cacheQuery, serviceCalled, cacheSet], timeout: 10.0, enforceOrder: true)
        
    }
    
    func testGetData_CacheMiss_ServiceError() async throws {
        
        let input = "My Input"
        
        let cacheQuery = expectation(description: "Cache is checked")
        let serviceCalled = expectation(description: "Service is called")
        
        let cut = CachingTaskService(
            dataProvider: FakeComponent<String, Int> { parameter in
                XCTAssertEqual(parameter, input)
                serviceCalled.fulfill()
                throw TestError()
            },
            cache: FakeCache<String, Int>(
                valueHandler: { key in
                    XCTAssertEqual(key, input)
                    cacheQuery.fulfill()
                    // Cache throws an exception on miss
                    throw CacheMiss()
                },
                setValueHandler: { value, key in
                    XCTFail("setValue should not be called")
                }
            )
        )
        
        do {
            _ = try await cut.getData(input: input)
            XCTFail("getData should throw")
        } catch {
            guard error is TestError else {
                XCTFail("Incorrect error type")
                return
            }
        }
        
        await fulfillment(of: [cacheQuery, serviceCalled], timeout: 10.0, enforceOrder: true)
        
    }
    
    func testGetData_CacheMiss_CacheWriteError() async throws {
        
        let input = "My Input"
        
        let expected = 149
        
        let cacheQuery = expectation(description: "Cache is checked")
        let serviceCalled = expectation(description: "Service is called")
        let cacheSet = expectation(description: "Cache is set")
        
        let cut = CachingTaskService(
            dataProvider: FakeComponent<String, Int> { parameter in
                XCTAssertEqual(parameter, input)
                serviceCalled.fulfill()
                return expected
            },
            cache: FakeCache<String, Int>(
                valueHandler: { key in
                    XCTAssertEqual(key, input)
                    cacheQuery.fulfill()
                    // Cache throws an exception on miss
                    throw CacheMiss()
                },
                setValueHandler: { value, key in
                    XCTAssertEqual(value, expected)
                    XCTAssertEqual(key, input)
                    cacheSet.fulfill()
                    throw TestError()
                }
            )
        )
        
        let result = try await cut.getData(input: input)
        
        XCTAssertEqual(result, expected)
        
        await fulfillment(of: [cacheQuery, serviceCalled, cacheSet], timeout: 10.0, enforceOrder: true)
        
    }

}
