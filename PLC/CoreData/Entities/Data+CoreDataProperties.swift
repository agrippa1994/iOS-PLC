//
//  Data+CoreDataProperties.swift
//  PLC
//
//  Created by Manuel Stampfl on 03.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Data: Indexable {

    @NSManaged var index: Int64
    @NSManaged var area: Int32
    @NSManaged var number: Int32
    @NSManaged var offset: Int32
    @NSManaged var bitLength: Int32
    @NSManaged var server: Server?

}
