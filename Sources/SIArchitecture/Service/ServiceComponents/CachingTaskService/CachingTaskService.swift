//
//  CachingTaskService.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation

public actor CachingTaskService<
    WrappedService: ArchitectureComponent,
    Cache: CacheProvider
>: Service where
    WrappedService.Input == Cache.Key,
    WrappedService.Output == Cache.Value
{
    
    private var taskCache = TaskCache<WrappedService.Input, WrappedService.Output>()
    private let service: WrappedService
    private let cache: Cache
    
    public init(dataProvider: WrappedService, cache: Cache) {
        self.service = dataProvider
        self.cache = cache
    }
    
    public func getData(input: WrappedService.Input) async throws -> WrappedService.Output {
        try await taskCache.task(forKey: input) { [service, cache] input in
            Task<WrappedService.Output, Error> {
                
                // If reading from the cache throws an error just move on to getting
                // the result from the service.
                if let existing = try? await cache.value(forKey: input) {
                    return existing
                }
                
                let result = try await service.getData(input: input)
                
                do {
                    try await cache.setValue(result, forKey: input)
                } catch {
                    // If caching fails, we still have a result, so return it.
                    NSLog("Failed to save value: \(result) to cache with key: \(input)")
                }
                
                return result
                
            }
        }
    }
    
}
