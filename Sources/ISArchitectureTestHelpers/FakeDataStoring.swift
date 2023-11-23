//
//  FakeDataStoring.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation
@testable import ISArchitecture

final class FakeDataStoring: DataStoring {
  
    let writeAction: @Sendable (String, URL) throws -> Void
    let readAction: @Sendable (URL) throws -> String
    
    init(
        writeAction: @escaping @Sendable (String, URL) throws -> Void,
        readAction: @escaping @Sendable (URL) throws -> String
    ) {
        self.writeAction = writeAction
        self.readAction = readAction
    }
    
    func write(_ data: String, toURL url: URL) throws {
        try writeAction(data, url)
    }
    
    func read(fromURL url: URL) throws -> String {
        try readAction(url)
    }
    
}
