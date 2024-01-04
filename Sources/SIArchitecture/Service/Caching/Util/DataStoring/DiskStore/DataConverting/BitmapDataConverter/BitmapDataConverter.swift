//
//  BitmapDataConverter.swift
//  BRBrowser
//
//  Created by Eric DeLabar on 11/15/23.
//

#if canImport(UIKit)

import UIKit

public final class BitmapDataConverter<ImageCoder: UIImageCoder>: DataConverting {

    public struct BadImageData: Error {}
    
    private let imageCoder: ImageCoder
    
    public init(imageCoder: ImageCoder) {
        self.imageCoder = imageCoder
    }
    
    public func encode(_ convertable: UIImage) throws -> Data {
        guard let data = imageCoder.jpegDataFor(uiImage: convertable) else {
            throw BadImageData()
        }
        
        return data
    }
    
    public func decode(data: Data) throws -> UIImage {
        guard let image = imageCoder.uiImageFrom(data: data) else {
            throw BadImageData()
        }
        
        return image
    }
    
}

#endif
