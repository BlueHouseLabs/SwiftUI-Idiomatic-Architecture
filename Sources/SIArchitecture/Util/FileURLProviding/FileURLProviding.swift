//
//  FileURLProviding.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public protocol FileURLProviding: Sendable {
    associatedtype Content: Sendable
    
    func fileURL(for: Content) -> URL
}
