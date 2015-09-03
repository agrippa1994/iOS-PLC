//
//  CoreData.swift
//  PLC
//
//  Created by Manuel Stampfl on 12.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation
import CoreData

private var sharedCoreData: CoreData?

class CoreData {
    class var coreData: CoreData {
        if sharedCoreData == nil {
            sharedCoreData = CoreData()
        }
        
        return sharedCoreData!
    }
    
    let servers = IndexableEntityHelper<Server>(name: "Server")
    let data = IndexableEntityHelper<Data>(name: "Data")
    
    private init() {
        
    }
    
    func save() {
        AppDelegate.singleton.saveContext()
    }
}