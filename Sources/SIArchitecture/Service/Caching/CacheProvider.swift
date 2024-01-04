//
//  CacheProvider.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation

public protocol CacheProvider: Sendable {
    associatedtype Key: Hashable & Sendable
    associatedtype Value: ComponentOutput
    
    func value(forKey key: Key) async throws -> Value
    func setValue(_ value: Value, forKey key: Key) async throws
}
