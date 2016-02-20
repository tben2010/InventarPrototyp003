//
//  Picture+CoreDataProperties.swift
//  InventarPrototyp003
//
//  Created by tben on 20.02.16|KW7.
//  Copyright © 2016 tben. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Picture {

    @NSManaged var id: NSNumber?
    @NSManaged var picture: NSData?
    @NSManaged var item: Item?

}
