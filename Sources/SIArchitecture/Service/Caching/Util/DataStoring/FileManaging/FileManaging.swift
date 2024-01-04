//
//  FileManaging.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/13/23.
//

import Foundation

public protocol FileManaging {
    
    func fileExists(atPath: String) -> Bool
    
    func removeItem(at URL: URL) throws
    
    func createDirectoriesForFile(url: URL) throws
    
}
