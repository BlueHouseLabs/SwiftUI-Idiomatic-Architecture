//
//  PersistedInMemoryCacheTests.swift
//  
//
//  Created by Eric DeLabar on 11/16/23.
//

import XCTest
@testable import BespokeTesting
@testable import SIArchitecture
@testable import SIArchitectureTestHelpers

final class PersistedInMemoryCacheTests: XCTestCase {
    
    let simpleRead: @Sendable ([String: String]?) async throws -> [String: String] = { existingData in
        guard let existingData else {
            throw TestError()
        }
        return existingData
    }
    
    let simpleWrite: @Sendable ([String: String]) async throws -> Void = { _ in
        
    }
    
    func testValueForKey_NewCache_BeforeLoad() async throws {
        
        let readFromEmptyCache = expectation(description: "Read from empty cache")
        let writeEmptyCache = expectation(description: "Write empty cache")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                if existingData == nil {
                    await self.fulfillment(of: [readFromEmptyCache], timeout: 10.0)
                }
                throw TestError()
            },
            writeCallback: { newCache in
                // Empty cache should be written to storage
                XCTAssertTrue(newCache.isEmpty)
                writeEmptyCache.fulfill()
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        do {
            _ = try await cut.value(forKey: "DoesNotExist")
            XCTFail("Call should throw.")
        } catch {
            readFromEmptyCache.fulfill()
        }
        
        await fulfillment(of: [writeEmptyCache], timeout: 10.0)
        
    }
    
    func testValueForKey_NewCache_AfterLoad() async throws {
        
        let writeEmptyCache = expectation(description: "Write empty cache")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                throw TestError()
            },
            writeCallback: { newCache in
                if newCache.isEmpty {
                    writeEmptyCache.fulfill()
                }
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await fulfillment(of: [writeEmptyCache], timeout: 10.0)
        
        let expectedNil = try? await cut.value(forKey: "DoesNotExist")
        
        XCTAssertNil(expectedNil)
        
    }
    
    func testValueForKey_EmptyCache_BeforeLoad() async throws {
        
        let readFromEmptyCache = expectation(description: "Read from empty cache")
        let writeEmptyCache = expectation(description: "Write empty cache")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                await self.fulfillment(of: [readFromEmptyCache], timeout: 10.0)
                return [:]
            },
            writeCallback: { newCache in
                // Empty cache should be written to storage
                XCTAssertTrue(newCache.isEmpty)
                writeEmptyCache.fulfill()
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        do {
            _ = try await cut.value(forKey: "DoesNotExist")
            XCTFail("Call should throw.")
        } catch {
            readFromEmptyCache.fulfill()
        }
        
        await fulfillment(of: [writeEmptyCache], timeout: 10.0)
        
    }
    
    func testValueForKey_EmptyCache_AfterLoad() async throws {
        
        let writeEmptyCache = expectation(description: "Write empty cache")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                [:]
            },
            writeCallback: { newCache in
                if newCache.isEmpty {
                    writeEmptyCache.fulfill()
                }
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await fulfillment(of: [writeEmptyCache], timeout: 10.0)
        
        let expectedNil = try? await cut.value(forKey: "DoesNotExist")
        
        XCTAssertNil(expectedNil)
        
    }
    
    func testValueForKey_NonEmptyCache_BeforeLoad() async throws {
        
        let readFromEmptyCache = expectation(description: "Read from empty cache")
        let writeEmptyCache = expectation(description: "Write empty cache")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                await self.fulfillment(of: [readFromEmptyCache], timeout: 10.0)
                return ["Key": "Value"]
            },
            writeCallback: { newCache in
                XCTAssertEqual(newCache, ["Key": "Value"])
                writeEmptyCache.fulfill()
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        do {
            _ = try await cut.value(forKey: "DoesNotExist")
            XCTFail("Call should throw.")
        } catch {
            readFromEmptyCache.fulfill()
        }
        
        await fulfillment(of: [writeEmptyCache], timeout: 10.0)
        
    }
    
    func testValueForKey_NonEmptyCache_AfterLoad() async throws {
        
        let writeEmptyCache = expectation(description: "Write empty cache")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                ["Key": "Value"]
            },
            writeCallback: { newCache in
                writeEmptyCache.fulfill()
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await fulfillment(of: [writeEmptyCache], timeout: 10.0)
        
        let expected = try? await cut.value(forKey: "Key")
        
        XCTAssertEqual(expected, "Value")
        
    }
    
    func testSetValueForKey_NewKey_NonEmptyCache_BeforeLoad() async throws {
        
        let writeCacheFromSet = expectation(description: "Write cache from set")
        let writeCacheFromLoad = expectation(description: "Write cache from load")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                // Pause initial read until first set completes
                await self.fulfillment(of: [writeCacheFromSet], timeout: 10.0)
                return ["ExistingKey": "ExistingValue"]
            },
            writeCallback: { newCache in
                if newCache.count == 1 {
                    XCTAssertEqual(newCache, ["NewKey": "NewValue"])
                    writeCacheFromSet.fulfill()
                } else {
                    XCTAssertEqual(newCache, [
                        "NewKey": "NewValue",
                        "ExistingKey": "ExistingValue",
                    ])
                    writeCacheFromLoad.fulfill()
                }
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await cut.setValue("NewValue", forKey: "NewKey")
        
        await fulfillment(of: [writeCacheFromLoad], timeout: 10.0)
        
    }
    
    func testSetValueForKey_NewKey_NonEmptyCache_AfterLoad() async throws {
        
        let writeCacheFromSet = expectation(description: "Write cache from set")
        let writeCacheFromLoad = expectation(description: "Write cache from load")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                return ["ExistingKey": "ExistingValue"]
            },
            writeCallback: { newCache in
                if newCache.count == 1 {
                    XCTAssertEqual(newCache, ["ExistingKey": "ExistingValue"])
                    writeCacheFromLoad.fulfill()
                } else {
                    XCTAssertEqual(newCache, [
                        "NewKey": "NewValue",
                        "ExistingKey": "ExistingValue",
                    ])
                    writeCacheFromSet.fulfill()
                }
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await fulfillment(of: [writeCacheFromLoad], timeout: 10.0)
        
        await cut.setValue("NewValue", forKey: "NewKey")
        
        await fulfillment(of: [writeCacheFromSet], timeout: 10.0)
        
    }
    
    func testSetValueForKey_NewValue_NonEmptyCache_BeforeLoad() async throws {
        
        let writeCacheFromSet = expectation(description: "Write cache from set")
        let writeCacheFromLoad = expectation(description: "Write cache from load")
        
        let counter = ConcurrentCounter()
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                await self.fulfillment(of: [writeCacheFromSet], timeout: 10.0)
                return ["ExistingKey": "ExistingValue"]
            },
            writeCallback: { newCache in
                let counter = await counter.increment()
                if counter == 1 {
                    XCTAssertEqual(newCache, ["ExistingKey": "NewValue"])
                    writeCacheFromSet.fulfill()
                } else {
                    XCTAssertEqual(newCache, [
                        "ExistingKey": "NewValue",
                    ])
                    writeCacheFromLoad.fulfill()
                }
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await cut.setValue("NewValue", forKey: "ExistingKey")
        
        await fulfillment(of: [writeCacheFromLoad], timeout: 10.0)
        
    }
    
    func testSetValueForKey_NewValue_NonEmptyCache_AfterLoad() async throws {
        
        let writeCacheFromSet = expectation(description: "Write cache from set")
        let writeCacheFromLoad = expectation(description: "Write cache from load")
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                return ["ExistingKey": "ExistingValue"]
            },
            writeCallback: { newCache in
                if newCache == ["ExistingKey": "ExistingValue"] {
                    writeCacheFromLoad.fulfill()
                } else {
                    XCTAssertEqual(newCache, [
                        "ExistingKey": "NewValue",
                    ])
                    writeCacheFromSet.fulfill()
                }
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await fulfillment(of: [writeCacheFromLoad], timeout: 10.0)
        
        await cut.setValue("NewValue", forKey: "ExistingKey")
        
        await fulfillment(of: [writeCacheFromSet], timeout: 10.0)
        
    }
    
    func testSetValueForKey_WriteErrorsAreIgnored() async throws {
        
        let writeCacheFromLoad = expectation(description: "Write cache from load")
        let writeCacheFromFirstSet = expectation(description: "Write cache from 1st set")
        let writeCacheFromSecondSet = expectation(description: "Write cache from 2nd set")
        
        let counter = ConcurrentCounter()
        
        let storage = FakePersistentStorage(
            history: [],
            readCallback: { existingData in
                return [:]
            },
            writeCallback: { newCache in
                let counter = await counter.increment()
                if counter == 1 {
                    XCTAssertTrue(newCache.isEmpty)
                    writeCacheFromLoad.fulfill()
                } else if counter == 2 {
                    XCTAssertEqual(newCache, [
                        "NewKey1": "NewValue1",
                    ])
                    writeCacheFromFirstSet.fulfill()
                    throw TestError()
                } else if counter == 3 {
                    XCTAssertEqual(newCache, [
                        "NewKey1": "NewValue1",
                        "NewKey2": "NewValue2",
                    ])
                    writeCacheFromSecondSet.fulfill()
                }
            }
        )

        let cut = PersistedInMemoryCache(fileStorage: storage)
        
        await fulfillment(of: [writeCacheFromLoad], timeout: 10.0)
        
        await cut.setValue("NewValue1", forKey: "NewKey1")
        
        await fulfillment(of: [writeCacheFromFirstSet], timeout: 10.0)
        
        await cut.setValue("NewValue2", forKey: "NewKey2")
        
        await fulfillment(of: [writeCacheFromSecondSet], timeout: 10.0)
        
    }

}
