//
//  NSManagedObject+Extention.swift
//  CoreDataToolbox
//
import Foundation
import CoreData

func objectcast<T>(object: AnyObject) -> T {
	return object as! T
}

extension NSManagedObject {
    //Statische Klassenmethoden ohne das eine Instanz nötig ist
	class func create(context: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext) -> Self {
		let entityName = getEntityName()
		let mangedObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context)
		return objectcast(mangedObject)
	}
	
	class func getEntityName () -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
	}
	
	class func fetchAll(
		context: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext,
		predicate:NSPredicate = NSPredicate(value: true)) -> [NSManagedObject]
	{
		let fetchRequest = NSFetchRequest(entityName: getEntityName())
		fetchRequest.predicate = predicate
		let array = try! context.executeFetchRequest(fetchRequest)
		return array as! [NSManagedObject]
	}
	
	class func fetchAllWithHandler(
		context: NSManagedObjectContext = CoreDataStack.sharedInstance.managedObjectContext,
		predicate:NSPredicate = NSPredicate(value: true),
		handler: (obj:NSManagedObject) -> Void)
	{
		let array = fetchAll(context, predicate: predicate)
		for object in array {
			handler(obj: object)
		}
	}

    class func saveRecord(){
        CoreDataStack.sharedInstance.saveContext()
    }
	
    class func deleteAllRecords(){
        fetchAllWithHandler { (obj) -> Void in
            obj.managedObjectContext?.deleteObject(obj)
        }
    }
    
    //Klassenmethoden, Instanz der Klasse notwendig
	func deleteRecord() {
		self.managedObjectContext?.deleteObject(self)
	}
    

}