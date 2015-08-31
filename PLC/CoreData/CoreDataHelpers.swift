//
//  CoreDataHelpers.swift
//  PLC
//
//  Created by Manuel Stampfl on 12.08.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import CoreData


// Each Core Data class with an index has to implement this protocol
protocol Indexable {
    var index: NSNumber { get set }
}

// This helper class helps the client to store and fetch data from Core Data
class EntityHelper<T where T: NSManagedObject> {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func all() -> [T] {
        if let ctx = AppDelegate.singleton.managedObjectContext {
            if let data = try? ctx.executeFetchRequest(NSFetchRequest(entityName: self.name)) as? [T] {
                return data!
            }
        }
        
        return []
    }
    
    func create(shouldSave: Bool = false) -> T? {
        if let ctx = AppDelegate.singleton.managedObjectContext {
            if let desc = NSEntityDescription.entityForName(self.name, inManagedObjectContext: ctx) {
                return NSManagedObject(entity: desc, insertIntoManagedObjectContext: shouldSave ? ctx : nil) as? T
            }
        }
        
        return nil
    }
    
    func insert(value: T) -> Bool {
        if let ctx = AppDelegate.singleton.managedObjectContext {
            ctx.insertObject(value)
            return true
        }
        
        return false
    }
    
    func remove(value: T) -> Bool {
        if let ctx = AppDelegate.singleton.managedObjectContext {
            ctx.deleteObject(value)
            return true
        }
        
        return false
    }
}

// This class works like EntityHelper but data is fetched and stored with an index
class IndexableEntityHelper<T where T: NSManagedObject, T: Indexable>: EntityHelper<T> {
    override init(name: String) {
        super.init(name: name)
    }
    
    override func all() -> [T] {
        var sorted = super.all().sort {
            return $0.index.compare($1.index) == NSComparisonResult.OrderedAscending
        }
        
        for var i = 0; i < sorted.count; i++ {
            sorted[i].index = NSNumber(integer: i)
        }
        
        return sorted
    }
    
    func move(fromIndex: Int, toIndex: Int) -> [T] {
        var data = self.all()
        data.move(fromIndex, toIndex: toIndex)
        
        for var i = 0; i < data.count; i++ {
            data[i].index = NSNumber(integer: i)
        }
        
        return data
    }
}
