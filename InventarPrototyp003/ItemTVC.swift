//
//  ItemTVC.swift
//  InventoryPrototyp002
//
//  Created by tben on 05.02.16|KW5.
//  Copyright © 2016 tben. All rights reserved.
//

import UIKit
import CoreData

class ItemTVC: UITableViewController {
    
    //MARK: - Variable
    var room:Room!

    //MARK: - NSFetchedResultsContoller Version für Swift 2.0
    private lazy var fetchedResultsController: NSFetchedResultsController! = {
        
        let request = NSFetchRequest(entityName: kItemEntity)
        request.predicate = NSPredicate(format: "room == %@", self.room)
        request.sortDescriptors = [NSSortDescriptor(key: kItemTitle, ascending: true)]
        
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
        
        title = room.title
        
        //Rechtes Pluszeichen
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addItem:")
        //let addButton =  UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addItem(_:)))
        
        navigationItem.setRightBarButtonItems([addButton], animated: true)
    }
    
    //MARK: - Methoden
    func addItem(sender:UIBarButtonItem){
        //Feldinhalte für den AlertController, mit NSLocalizedString wegen Übersetzung
        let title = NSLocalizedString("titleCreateItem",value:"Create New Item", comment: "title in alert Controller")
        let placeholder = NSLocalizedString("placeholderCreateRoom",value:"Item", comment: "placeholder in alert Controller")
        let message = NSLocalizedString("placeholderCreateItem",value:"Type in or dictate a item. Press >OK< to save. The dialog will pop up again so that it is easy to create a number of items. Press >Cancel< if your item list is complete.", comment: "message in alert Controller")
        let ok = NSLocalizedString("OkButtonCreateItem",value:"OK", comment: "Label OK in alert Controller")
        let cancel = NSLocalizedString("CancelButtonCreateItem",value:"Cancel", comment: "Label Cancel in alert Controller")
        let dialog = TBENHelper.singleTextFieldDialogWithTitle(title, message: message, placeholder: placeholder, textFieldValue: "", ok: ok, cancel: cancel) { [weak self] (text) in
            
            Item.createItemForRoom(self!.room, withTitle: text)
            
            TBENHelper.delayOnMainQueue(0.3, closure: {
                self?.addItem(sender)
            })
            
        }
        
        presentViewController(dialog, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kFromItemToImage {
            let detailController = segue.destinationViewController as? PictureTVC
            if let indexPath = tableView.indexPathForSelectedRow {
                if let item = fetchedResultsController.objectAtIndexPath(indexPath) as? Item {
                    detailController?.item = item
                }
            }
            
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section])?.numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kItemCell, forIndexPath: indexPath) as! ItemCell
        cell.item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
            item.deleteRecord()
        }
    }
}

//Version Swift 2.0
extension ItemTVC: NSFetchedResultsControllerDelegate{
    
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

