//
//  CodableDataConverter.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public final class CodableDataConverter<ConvertableData: Codable & Sendable>: DataConverting {
    
    public func encode(_ convertable: ConvertableData) throws -> Data {
        try JSONEncoder().encode(convertable)
    }
    
    public func decode(data: Data) throws -> ConvertableData {
        try JSONDecoder().decode(ConvertableData.self, from: data)
    }
    
    public init() {}
    
}
