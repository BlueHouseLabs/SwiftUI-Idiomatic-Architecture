//
//  FakePersistentStorage.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

@testable import SIArchitecture

actor FakePersistentStorage: PersistentStorage {
    
    var history: [[String: String]]
    
    let readCallback: @Sendable ([String: String]?) async throws -> [String: String]
    let writeCallback: @Sendable ([String: String]) async throws -> Void
    
    init(
        history: [[String : String]] = [],
        readCallback: @escaping @Sendable ([String: String]?) async throws -> [String: String],
        writeCallback: @escaping @Sendable ([String: String]) async throws -> Void
    ) {
        self.history = history
        self.readCallback = readCallback
        self.writeCallback = writeCallback
    }
    
    func write(_ storable: [String : String]) async throws {
        history.append(storable)
        try await writeCallback(storable)
    }
    
    func read() async throws -> [String : String] {
        try await readCallback(history.last)
    }
    
}
