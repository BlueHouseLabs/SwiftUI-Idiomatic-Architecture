//
//  FakeFileManager.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation
@testable import BespokeTesting
@testable import SIArchitecture

final class FakeFileManager: FileManaging {
    
    let fileExistsHandler: @Sendable (String) -> Bool
    let removeItemHandler: @Sendable (URL) throws -> Void
    let createDirectoriesForFileHandler: @Sendable (URL) throws -> Void
    
    init(
        fileExistsHandler: @escaping @Sendable (String) -> Bool = {_ in false },
        removeItemHandler: @escaping @Sendable (URL) throws -> Void = { _ in throw TestError() },
        createDirectoriesForFileHandler: @escaping @Sendable (URL) throws -> Void = { _ in throw TestError() }
    ) {
        self.fileExistsHandler = fileExistsHandler
        self.removeItemHandler = removeItemHandler
        self.createDirectoriesForFileHandler = createDirectoriesForFileHandler
    }
    
    func fileExists(atPath path: String) -> Bool {
        fileExistsHandler(path)
    }
    
    func removeItem(at url: URL) throws {
        try removeItemHandler(url)
    }
    
    func createDirectoriesForFile(url: URL) throws {
        try createDirectoriesForFileHandler(url)
    }
    
    
}
