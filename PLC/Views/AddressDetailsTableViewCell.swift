//
//  AddressDetailsTableViewCell.swift
//  PLC
//
//  Created by Manuel Stampfl on 06.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class AddressDetailsTableViewCell: UITableViewCell {
    var entry: S7Entry? {
        didSet {
            if self.guiLoaded {
                self.loadDetailsToUI()
            }
        }
    }
    
    var guiLoaded = false
    var typeLabel: UILabel!
    var lengthLabel: UILabel!
    var startLabel: UILabel!
    var offsetLabel: UILabel!
    var bitOffsetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.typeLabel = self.viewWithTag(100) as! UILabel
        self.lengthLabel = self.viewWithTag(101) as! UILabel
        self.startLabel = self.viewWithTag(102) as! UILabel
        self.offsetLabel = self.viewWithTag(103) as! UILabel
        self.bitOffsetLabel = self.viewWithTag(104) as! UILabel
        
        self.guiLoaded = true
        self.loadDetailsToUI()
    }
    
    func loadDetailsToUI() {
        self.typeLabel.text = "ADDRESSDETAILSTABLEVIEWCELL_TYPE".localized
            + ((self.entry == nil) ? "ADDRESSDETAILSTABLEVIEWCELL_UNKNOWN".localized
                : "\(self.entry!.type)")
        
        self.lengthLabel.text = "ADDRESSDETAILSTABLEVIEWCELL_LENGTH".localized
            + ((self.entry == nil) ? "ADDRESSDETAILSTABLEVIEWCELL_UNKNOWN".localized
                : "\(self.entry!.bitLength)")
        
        self.startLabel.text = "ADDRESSDETAILSTABLEVIEWCELL_START".localized
            + ((self.entry == nil) ? "ADDRESSDETAILSTABLEVIEWCELL_UNKNOWN".localized
                : "\(self.entry!.start)")
        
        self.offsetLabel.text = "ADDRESSDETAILSTABLEVIEWCELL_OFFSET".localized
            + ((self.entry == nil) ? "ADDRESSDETAILSTABLEVIEWCELL_UNKNOWN".localized
                : self.entry!.offset == nil ? "ADDRESSDETAILSTABLEVIEWCELL_NONE".localized
                : "\(self.entry!.offset!)")
        
        self.bitOffsetLabel.text = "ADDRESSDETAILSTABLEVIEWCELL_BITOFFSET".localized
            + ((self.entry == nil) ? "ADDRESSDETAILSTABLEVIEWCELL_UNKNOWN".localized
                : self.entry!.bitOffset == nil ? "ADDRESSDETAILSTABLEVIEWCELL_NONE".localized
                : "\(self.entry!.bitOffset!)")
    }
}
