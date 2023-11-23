//
//  ConvertingDataProvider.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

import Foundation

public final class ConvertingDataService<
    InputConverter: Converter,
    WrappedService: Service,
    OutputConverter: Converter
>: ArchitectureComponent where
    InputConverter.Input: ComponentInput,
    OutputConverter.Output: ComponentOutput,
    WrappedService.Input == InputConverter.Output,
    WrappedService.Output == OutputConverter.Input
{
    private let inputConverter: InputConverter
    private let service: WrappedService
    private let outputConverter: OutputConverter
    
    public init(
        inputConverter: InputConverter,
        service: WrappedService,
        outputConverter: OutputConverter
    ) {
        self.inputConverter = inputConverter
        self.service = service
        self.outputConverter = outputConverter
    }
    
    public func getData(input: InputConverter.Input) async throws -> OutputConverter.Output {
        try await outputConverter.convert(
            service.getData(
                input: inputConverter.convert(input)
            )
        )
    }
}

// These aren't actually used, but this is demonstrating how they could be used in other service compositions...

public final class IdentityConverter<T: Sendable>: Converter {
    public func convert(_ input: T) throws -> T {
        input
    }
}

extension ConvertingDataService {
    
    public convenience init(inputConverter: InputConverter, service: WrappedService) where OutputConverter == IdentityConverter<WrappedService.Output> {
        self.init(
            inputConverter: inputConverter,
            service: service,
            outputConverter: IdentityConverter()
        )
    }
    
    public convenience init(service: WrappedService, outputConverter: OutputConverter) where InputConverter == IdentityConverter<WrappedService.Input> {
        self.init(
            inputConverter: IdentityConverter(),
            service: service,
            outputConverter: outputConverter
        )
    }
    
}
