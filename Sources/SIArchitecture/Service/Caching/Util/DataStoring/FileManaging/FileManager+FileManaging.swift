//
//  FileManager+FileManaging.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

extension FileManager: FileManaging {
    
    public func createDirectoriesForFile(url: URL) throws {
        let directory = url.deletingLastPathComponent()
        guard !fileExists(atPath: directory.path) else {
            return
        }
        try createDirectory(at: directory, withIntermediateDirectories: true)
    }
    
}
