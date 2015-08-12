//
//  Server.swift
//  PLC
//
//  Created by Manuel Stampfl on 12.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation
import CoreData

class Server: NSManagedObject, Indexable {

    @NSManaged var host: String
    @NSManaged var index: NSNumber
    @NSManaged var connectionType: NSNumber
    @NSManaged var rack: NSNumber
    @NSManaged var slot: NSNumber
    @NSManaged var name: String

}
