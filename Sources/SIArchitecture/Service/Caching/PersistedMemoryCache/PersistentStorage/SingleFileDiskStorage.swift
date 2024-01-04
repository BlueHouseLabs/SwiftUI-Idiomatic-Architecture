//
//  SingleFileDiskStorage.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public actor SingleFileDiskStorage<Store: DataStoring>: PersistentStorage {
    
    private let file: URL
    private let store: Store
    
    public init(file: URL, store: Store) {
        self.file = file
        self.store = store
    }
    
    public func write(_ storable: Store.StorableData) throws {
        try store.write(storable, toURL: file)
    }
    
    public func read() throws -> Store.StorableData {
        try store.read(fromURL: file)
    }
    
}
