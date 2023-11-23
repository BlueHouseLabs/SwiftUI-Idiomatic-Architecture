//
//  DataStoring.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public protocol DataStoring: Sendable {
    associatedtype StorableData: Sendable
    
    func write(_ data: StorableData, toURL url: URL) throws
    func read(fromURL: URL) throws -> StorableData
}
