//
//  DiskStore.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public final class DiskStore<DataConverter: DataConverting, FileManager: FileManaging>: DataStoring {
    
    private let dataConverter: DataConverter
    private let fileManagerFactory: @Sendable () -> FileManager
    
    private var fileManager: FileManager {
        fileManagerFactory()
    }
    
    public init(dataConverter: DataConverter, fileManagerFactory: @Sendable @escaping () -> FileManager) {
        self.dataConverter = dataConverter
        self.fileManagerFactory = fileManagerFactory
    }
    
    public func write(_ data: DataConverter.ConvertableData, toURL url: URL) throws {
        
        // If the directory doesn't exist the write will fail.
        try fileManager.createDirectoriesForFile(url: url)
        
        // THIS ACTUALLY WRITES TO THE FILESYSTEM
        try dataConverter.encode(data).write(to: url, options: .atomic)
    }
    
    public func read(fromURL url: URL) throws -> DataConverter.ConvertableData {
        // THIS ACTUALLY READS FROM THE FILESYSTEM
        try dataConverter.decode(data: Data(contentsOf: url))
    }
    
}


