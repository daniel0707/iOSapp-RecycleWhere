//
//  RadialGradientView.swift
//  Pretium
//
//  Created by Staham Nguyen on 31/07/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class RadialGradientView: UIView {

    var insideColor: UIColor = UIColor.clear
    var outsideColor: UIColor = UIColor.clear
    
    override internal func draw(_ rect: CGRect) {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = CGFloat(500)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: CGFloat(endRadius), options: .drawsAfterEndLocation)
    }

}
