//
//  UIImageBuilder.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

#if canImport(UIKit)

import UIKit

public final class UIImageBuilder: Building {
    
    public struct InvalidImageContent: Error {}
    
    public init() {}
    
    public func buildFrom(url: URL) throws -> UIImage {
        let data = try Data(contentsOf: url)
        guard let uiImage = UIImage(data: data) else {
            throw InvalidImageContent()
        }
        return uiImage
    }
}

#endif
