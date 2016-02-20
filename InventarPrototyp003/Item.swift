//
//  Item.swift
//  InventarPrototyp003
//
//  Created by tben on 20.02.16|KW7.
//  Copyright © 2016 tben. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static func createItemForRoom (room:Room, withTitle title:String) -> Item {
        let item = NSEntityDescription.insertNewObjectForEntityForName(kItemEntity, inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! Item
        item.room = room
        item.title = title
        CoreDataStack.sharedInstance.saveContext()
        return item
    }

}
