//
//  Server+CoreDataProperties.swift
//  PLC
//
//  Created by Manuel Stampfl on 08.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Server: Indexable {

    @NSManaged var host: String?
    @NSManaged var index: Int64
    @NSManaged var name: String?
    @NSManaged var rack: Int32
    @NSManaged var slot: Int32
    @NSManaged var data: NSSet?

}
