//
//  BitView.swift
//  PLC
//
//  Created by Manuel Stampfl on 08.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class BitView: UIView {
    var bit = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var enabled = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override internal func drawRect(rect: CGRect) {
        let rectanglePath = UIBezierPath(rect: rect)
        
        // Set the background color depending on the enabled and bit state
        (
            self.enabled
                ?(self.bit
                    ? UIColor.flatGreenColor()
                    : UIColor.flatRedColor()
                )
                : UIColor.flatGrayColor()
        )
        .setFill()
        
        rectanglePath.fill()
        UIColor.blackColor().setStroke()
        rectanglePath.lineWidth = 3
        rectanglePath.stroke()
    }
}
