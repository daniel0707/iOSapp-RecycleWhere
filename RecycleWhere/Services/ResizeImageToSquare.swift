//
//  ResizeImageToSquare.swift
//  RecycleWhere
//
//  Created by Staham Nguyen on 02/05/2018.
//  Copyright © 2018 RecycleWhere. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func scaleImageToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
