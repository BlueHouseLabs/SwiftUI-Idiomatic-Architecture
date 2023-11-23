//
//  PersistedInMemoryCache.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/13/23.
//

import Foundation

public actor PersistedInMemoryCache<Input: ComponentInput, Output: ComponentOutput & Codable, Store: PersistentStorage>: CacheProvider where Store.StorableData == [Input: Output] {
    
    public struct NotFoundError: Error {}
    
    private var cache: [Input: Output]
    private let fileStorage: Store
    
    public init(fileStorage: Store) {
        cache = [Input: Output]()
        self.fileStorage = fileStorage
        Task {
            do {
                let data = try await fileStorage.read()
                await loadCache(data)
            } catch {
                NSLog("Error loading cache from file.")
                await writeCache()
            }
        }
    }
    
    public func value(forKey key: Input) throws -> Output {
        guard let value = cache[key] else {
            throw NotFoundError()
        }
        return value
    }
    
    public func setValue(_ value: Output, forKey key: Input) {
        cache[key] = value
        writeCache()
    }
    
    private func loadCache(_ data: [Input: Output]) {
        cache = data.reduce(into: cache) { cache, kvp in
            guard cache[kvp.key] == nil else {
                // Don't replace anything already in the cache
                return
            }
            cache[kvp.key] = kvp.value
        }
        writeCache()
    }
    
    private func writeCache() {
        let copy = cache
        Task {
            do {
                try await fileStorage.write(copy)
            } catch {
                NSLog("Error writing cache to file.")
            }
        }
    }
    
}
