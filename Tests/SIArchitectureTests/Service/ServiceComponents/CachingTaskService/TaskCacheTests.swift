//
//  TaskCacheTests.swift
//  BRBrowserTests
//
//  Created by Eric DeLabar on 11/13/23.
//

import XCTest
@testable import SIArchitecture

final class TaskCacheTests: XCTestCase {
    
    let yahoo = URL(string: "https://www.yahoo.com/")!

    func testNoTasks() async throws {
        
        let google = URL(string: "https://www.google.com/")!
        
        let taskBuilder: @Sendable (URL) -> Task<String, Error> = { url in
            Task<String, Error> {
                try await Task.sleep(nanoseconds: 1000)
                return "Hello World"
            }
        }
        
        let testCache = TaskCache<URL, String>()
        
        let result = try await testCache.task(forKey: google, taskBuilder: taskBuilder)
        
        XCTAssertEqual(result, "Hello World")
        
    }
    
    func testRunningTask() async throws {
        
        let google = URL(string: "https://www.google.com/")!
        
        let expectOnlyOneExecution = expectation(description: "Task should only be called once.")
        
        let taskBuilder: @Sendable (URL) -> Task<String, Error> = { url in
            Task<String, Error> {
                // Need just enough delay that the first task is still executing when the second starts.
                try await Task.sleep(nanoseconds: 100_000)
                expectOnlyOneExecution.fulfill()
                return "Hello World"
            }
        }
        
        let testCache = TaskCache<URL, String>()
        
        async let asyncResult1 = try await testCache.task(forKey: google, taskBuilder: taskBuilder)
        async let asyncResult2 = try await testCache.task(forKey: google, taskBuilder: taskBuilder)
        
        let result = (try await asyncResult1, try await asyncResult2)
        
        await fulfillment(of: [expectOnlyOneExecution], timeout: 20.0)
        
        XCTAssertEqual(result.0, "Hello World")
        XCTAssertEqual(result.1, "Hello World")
        
    }

}
