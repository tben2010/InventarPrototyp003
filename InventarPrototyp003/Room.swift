//
//  Room.swift
//  InventarPrototyp003
//
//  Created by tben on 20.02.16|KW7.
//  Copyright © 2016 tben. All rights reserved.
//

import Foundation
import CoreData


class Room: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    static func createRoomWithTitle (title:String) -> Room {
        let room = NSEntityDescription.insertNewObjectForEntityForName(kRoomEntity, inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! Room
        room.title = title
        CoreDataStack.sharedInstance.saveContext()
        return room
    }

}
