//
//  FileCache.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public actor FileCache<
    URLProvider: FileURLProviding,
    Store: DataStoring
>: CacheProvider where URLProvider.Content: Hashable {
    
    private let fileStorage: Store
    private let urlProvider: URLProvider
    
    public init(
        urlProvider: URLProvider,
        fileStorage: Store
    ) {
        self.urlProvider = urlProvider
        self.fileStorage = fileStorage
    }
    
    public func value(forKey key: URLProvider.Content) async throws -> Store.StorableData {
        try fileStorage.read(fromURL: urlProvider.fileURL(for: key))
    }
    
    public func setValue(_ value: Store.StorableData, forKey key: URLProvider.Content) async throws {
        try fileStorage.write(value, toURL: urlProvider.fileURL(for: key))
    }
    
}
