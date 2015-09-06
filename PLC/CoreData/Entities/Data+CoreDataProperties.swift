//
//  Data+CoreDataProperties.swift
//  PLC
//
//  Created by Manuel Stampfl on 06.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Data: Indexable {

    @NSManaged var index: Int64
    @NSManaged var address: String?
    @NSManaged var displayType: Int32
    @NSManaged var name: String?
    @NSManaged var server: Server?

}
