//
//  FakeBuilder.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

import Foundation
@testable import BespokeTesting
@testable import SIArchitecture

final class FakeBuilder<Built: Sendable>: Building {
    
    let build: @Sendable (URL) throws -> Built?
    
    init(build: @escaping @Sendable (URL) -> Built?) {
        self.build = build
    }
    
    convenience init(building: Built?) {
        self.init { _ in
            building
        }
    }
    
    func buildFrom(url: URL) throws -> Built {
        guard let result = try build(url) else {
            throw TestError()
        }
        
        return result
    }
    
}
