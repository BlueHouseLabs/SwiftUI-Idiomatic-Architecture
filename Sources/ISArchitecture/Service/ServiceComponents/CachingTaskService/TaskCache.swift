//
//  TaskCache.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/13/23.
//

import Foundation

// This should have methods to evict old Tasks from the cache, but the dataset is small
// enough in the sample code that it doesn't matter.
public actor TaskCache<Key: Hashable, Data: Sendable> {
    
    private var cache: [Key: Task<Data, Error>]

    public init(
        cache: [Key : Task<Data, Error>] = [Key: Task<Data, Error>]()
    ) {
        self.cache = cache
    }
    
    public func task(
        forKey key: Key,
        taskBuilder: @Sendable @escaping (Key) -> Task<Data, Error>
    ) async throws -> Data {
        
        if let task = cache[key] {
            return try await task.value
        }
        
        let task = taskBuilder(key)
        cache[key] = task

        defer {
            // Once we have a value (or an exception) remove the task from the cache
            // * On success we'll rely on upper layers to cache the result of business logic
            // * On exception we want subsequent calls for the same url to return a potential success
            cache.removeValue(forKey: key)
        }
        
        return try await task.value
        
    }
    
}
