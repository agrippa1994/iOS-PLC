//
//  String+Localization.swift
//  PLC
//
//  Created by Manuel Stampfl on 03.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}