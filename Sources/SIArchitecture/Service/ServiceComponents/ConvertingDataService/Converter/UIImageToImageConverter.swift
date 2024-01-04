//
//  UIImageToImageConverter.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

#if canImport(UIKit)

import SwiftUI

public final class UIImageToImageConverter: Converter {
    
    public init() {}
    
    public func convert(_ input: UIImage) throws -> Image {
        Image(uiImage: input)
    }
    
}

#endif
