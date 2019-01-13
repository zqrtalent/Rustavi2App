//
//  UIImageExtension.swift
//  Rustavi2TvShared
//
//  Created by Zaqro Butskrikidze on 12/29/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage{
    public func scaleImage(scaleCX: CGFloat, scaleCY: CGFloat) -> UIImage?{
        guard let cgImage = self.cgImage else{
            return nil
        }
        
        guard let clrSpace = cgImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB) else{
            return nil
        }
        
        guard let imageContext = CGContext(data: nil, width: Int(size.width*scaleCX), height: Int(size.height*scaleCY), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: clrSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return nil
        }
        
        imageContext.interpolationQuality = .high
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: size))
        guard let imageNew = imageContext.makeImage() else{
            return nil
        }
        
        return UIImage.init(cgImage: imageNew)
    }
}
