//
//  UIImageCoder.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

#if canImport(UIKit)

import UIKit

public protocol UIImageCoder: Sendable {
    
    func jpegDataFor(uiImage: UIImage) -> Data?
    func uiImageFrom(data: Data) -> UIImage?
    
}

#endif
