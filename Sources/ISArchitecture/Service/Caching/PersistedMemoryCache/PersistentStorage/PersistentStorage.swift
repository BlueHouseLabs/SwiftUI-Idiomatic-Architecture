//
//  PersistentStorage.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public protocol PersistentStorage: Sendable {
    associatedtype StorableData: Sendable
    
    func write(_ storable: StorableData) async throws
    func read() async throws -> StorableData
}
