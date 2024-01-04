//
//  ArchitectureComponent.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation

public typealias ComponentInput = Sendable & Hashable & Codable
public typealias ComponentOutput = Sendable

public protocol ArchitectureComponent: Sendable {
    associatedtype Input: ComponentInput
    associatedtype Output: ComponentOutput
    
    func getData(input: Input) async throws -> Output
}

public protocol Repository: ArchitectureComponent {}

public protocol Service: ArchitectureComponent {}
