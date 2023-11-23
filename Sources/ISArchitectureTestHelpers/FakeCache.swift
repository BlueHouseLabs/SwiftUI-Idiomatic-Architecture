//
//  FakeCache.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

@testable import ISArchitecture

final class FakeCache<Input: ComponentInput, Output: ComponentOutput>: CacheProvider {
    
    let valueHandler: @Sendable (Input) throws -> Output
    let setValueHandler: @Sendable (Output, Input) throws -> Void
    
    init(
        valueHandler: @escaping @Sendable (Input) throws -> Output,
        setValueHandler: @escaping @Sendable (Output, Input) throws -> Void
    ) {
        self.valueHandler = valueHandler
        self.setValueHandler = setValueHandler
    }
    
    func value(forKey key: Input) async throws -> Output {
        try valueHandler(key)
    }
    
    func setValue(_ value: Output, forKey key: Input) async throws {
        try setValueHandler(value, key)
    }
    
}
