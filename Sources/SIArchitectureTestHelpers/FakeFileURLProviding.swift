//
//  FakeFileURLProviding.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation
@testable import SIArchitecture

final class FakeFileURLProviding<Content: Sendable>: FileURLProviding {
    
    let fileURLHandler: @Sendable (Content) -> URL
    
    init(fileURLHandler: @escaping @Sendable (Content) -> URL) {
        self.fileURLHandler = fileURLHandler
    }
    
    func fileURL(for content: Content) -> URL {
        fileURLHandler(content)
    }
    
}
