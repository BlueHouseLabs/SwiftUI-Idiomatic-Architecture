//
//  DataConverting.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public protocol DataConverting: Sendable {
    associatedtype ConvertableData: Sendable
    
    func encode(_ convertable: ConvertableData) throws -> Data
    func decode(data: Data) throws -> ConvertableData
}
