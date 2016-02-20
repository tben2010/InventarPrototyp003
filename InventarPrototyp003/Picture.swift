//
//  Picture.swift
//  InventarPrototyp003
//
//  Created by tben on 20.02.16|KW7.
//  Copyright © 2016 tben. All rights reserved.
//

import Foundation
import CoreData


class Picture: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    static func createPictureForItem (item:Item, withImageData imageData:NSData, withID id:Int) -> Picture {
        let picture = NSEntityDescription.insertNewObjectForEntityForName(kPictureEntity, inManagedObjectContext: CoreDataStack.sharedInstance.managedObjectContext) as! Picture
        picture.item = item
        picture.picture = imageData
        CoreDataStack.sharedInstance.saveContext()
        return picture
    }
}
