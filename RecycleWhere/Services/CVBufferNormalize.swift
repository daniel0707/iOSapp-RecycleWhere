//
//  CVBufferNormalize.swift
//  RecycleWhere
//
//  Created by iosdev on 7.5.2018.
//  Copyright © 2018 RecycleWhere. All rights reserved.
//

import Foundation
import UIKit

extension CVPixelBuffer {
    
    func normalize() {
        
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        
        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(self), to: UnsafeMutablePointer<Float>.self)
        
        var minPixel: Float = 1.0
        var maxPixel: Float = 0.0
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                let pixel = floatBuffer[y * width + x]
                minPixel = min(pixel, minPixel)
                maxPixel = max(pixel, maxPixel)
            }
        }
        
        let range = maxPixel - minPixel
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                let pixel = floatBuffer[y * width + x]
                //floatBuffer[y * width + x] = (pixel - minPixel) / range
                floatBuffer[y * width + x] = pixel/255.0

            }
        }
        
        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
    }
}
