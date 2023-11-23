//
//  FakeComponent.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

@testable import ISArchitecture

final class FakeComponent<Input: ComponentInput, Output: ComponentOutput>: ArchitectureComponent {
    
    let getDataHandler: @Sendable (Input) throws -> Output
    
    init(getDataHandler: @escaping @Sendable (Input) throws -> Output) {
        self.getDataHandler = getDataHandler
    }
    
    func getData(input: Input) async throws -> Output {
        try getDataHandler(input)
    }
    
}
