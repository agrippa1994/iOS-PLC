//
//  Array+Move.swift
//  PLC
//
//  Created by Manuel Stampfl on 13.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

extension Array {
    mutating func move(fromIndex: Int, toIndex: Int) {
        var obj = self.removeAtIndex(fromIndex)
        self.insert(obj, atIndex: toIndex)
    }
}