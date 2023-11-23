//
//  FakeDataConverter.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation
@testable import BespokeTesting
@testable import ISArchitecture

final class FakeDataConverter: DataConverting {
    
    let encoder: @Sendable (String) throws -> Data
    let decoder: @Sendable (Data) throws -> String
    
    init(
        encoder: @escaping @Sendable (String) throws -> Data,
        decoder: @escaping @Sendable (Data) throws -> String
    ) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func encode(_ convertable: String) throws -> Data {
        try encoder(convertable)
    }
    
    func decode(data: Data) throws -> String {
        try decoder(data)
    }
    
}
