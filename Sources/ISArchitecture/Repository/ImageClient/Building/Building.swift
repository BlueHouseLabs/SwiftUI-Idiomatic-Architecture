//
//  Building.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public protocol Building: Sendable {
    associatedtype Built: Sendable
    
    func buildFrom(url: URL) throws -> Built
}
