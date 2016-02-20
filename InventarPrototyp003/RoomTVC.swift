//
//  InventoryTVC.swift
//  InventoryPrototyp002
//
//  Created by tben on 05.02.16|KW5.
//  Copyright © 2016 tben. All rights reserved.
//

import UIKit
import CoreData

class RoomTVC: UITableViewController {
    //MARK: - Variable
    //MARK: - NSFetchedResultsContoller Version für Swift 2.0
    private lazy var fetchedResultsController: NSFetchedResultsController! = {
        
        let request = NSFetchRequest(entityName: kRoomEntity)
        request.sortDescriptors = [NSSortDescriptor(key: kRoomTitle, ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //Damit das funktioniert muss das NSFetchedResultsControllerDelegate Protokoll implementiert sein
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch let error as NSError {
            print(error)
        }
        
        return fetchedResultsController
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Title für den TableViewController, mit NSLocalizedString wegen Übersetzung
        title = NSLocalizedString("titleRoomViewController", value: "Room", comment: "Title from Room List")
        
        //Rechtes Pluszeichen
        let addButton =  UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addRoom:")
        
        navigationItem.setRightBarButtonItems([addButton], animated: true)
        
    }
    
    
    //MARK: - Methoden
    func addRoom(sender:UIBarButtonItem){
        //Feldinhalte für den AlertController, mit NSLocalizedString wegen Übersetzung
        let title = NSLocalizedString("titleCreateRoom",value:"Create New Room", comment: "title in alert Controller")
        let placeholder = NSLocalizedString("placeholderCreateRoom",value:"Room", comment: "placeholder in alert Controller")
        let message = NSLocalizedString("placeholderCreateRoom",value:"Type in or dictate a room. Press >OK< to save. The dialog will pop up again so that it is easy to create a number of rooms. Press >Cancel< if your room list is complete.", comment: "message in alert Controller")
        let ok = NSLocalizedString("OkButtonCreateRoom",value:"OK", comment: "Label OK in alert Controller")
        let cancel = NSLocalizedString("CancelButtonCreateRoom",value:"Cancel", comment: "Label Cancel in alert Controller")
        let dialog = TBENHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: "", ok: ok, cancel: cancel) { [weak self] (text) in
            
            Room.createRoomWithTitle(text)
            
            TBENHelper.delayOnMainQueue(0.3, closure: { 
                self?.addRoom(sender)
            })
            
        }
        
        presentViewController(dialog, animated: true, completion: nil)
        
        
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section])?.numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kRoomCell, forIndexPath: indexPath) as! RoomCell
        cell.room = fetchedResultsController.objectAtIndexPath(indexPath) as! Room
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let room = fetchedResultsController.objectAtIndexPath(indexPath) as! Room
            room.deleteRecord()
        }
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kFromRoomToItems {
            let detailController = segue.destinationViewController as? ItemTVC
            if let indexPath = tableView.indexPathForSelectedRow {
                if let room = fetchedResultsController.objectAtIndexPath(indexPath) as? Room {
                    detailController?.room = room
                }
            }
            
        }
    }
}

//Version Swift 2.0
extension RoomTVC: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            print("Insert")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Update:
            print("Update")
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Delete:
            print("Delete")
            tableView.deleteRowsAtIndexPaths([indexPath!],withRowAnimation: .Automatic)
        case .Move:
            print("Move")
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
}
