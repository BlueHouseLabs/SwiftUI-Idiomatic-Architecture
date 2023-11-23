//
//  FileManager+DirectoryHelpers.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public extension FileManager {
    
    var cacheDirectory: URL {
        urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    var documentsDirectory: URL {
        urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
}
