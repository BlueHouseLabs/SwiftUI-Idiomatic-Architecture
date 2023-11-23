//
//  SystemUIImageCoder.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

#if canImport(UIKit)

import UIKit

public final class SystemUIImageCoder: UIImageCoder {
    
    private let jpegQuality: CGFloat
    
    public init(jpegQuality: CGFloat) {
        self.jpegQuality = jpegQuality
    }
    
    public func jpegDataFor(uiImage: UIImage) -> Data? {
        uiImage.jpegData(compressionQuality: jpegQuality)
    }
    
    public func uiImageFrom(data: Data) -> UIImage? {
        UIImage(data: data)
    }
    
}

#endif
