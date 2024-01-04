//
//  FakeImageCoder.swift
//
//  Created by Eric DeLabar on 11/14/23.
//

#if canImport(UIKit)

import UIKit
@testable import SIArchitecture

final class FakeImageCoder: UIImageCoder {
    
    let data: Data?
    let image: UIImage?
    
    init(
        data: Data? = nil,
        image: UIImage? = nil
    ) {
        self.data = data
        self.image = image
    }
    
    func jpegDataFor(uiImage: UIImage) -> Data? {
        data
    }
    
    func uiImageFrom(data: Data) -> UIImage? {
        image
    }
    
}

#endif
