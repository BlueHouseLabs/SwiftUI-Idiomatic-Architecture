//
//  Converter.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public protocol Converter: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable
    
    func convert(_ input: Input) throws -> Output
}
