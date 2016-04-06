//
//  PictureTVC.swift
//  InventoryPrototyp002
//
//  Created by tben on 05.02.16|KW5.
//  Copyright © 2016 tben. All rights reserved.
//

import UIKit
import CoreData

class PictureTVC: UITableViewController {
    
    //MARK: - Variable
    var item:Item!
    let imagePicker = UIImagePickerController()
    var count:Int = 0

    //MARK: - NSFetchedResultsContoller Version für Swift 2.0
    private lazy var fetchedResultsController: NSFetchedResultsController! = {
        
        let request = NSFetchRequest(entityName: kPictureEntity)
        request.predicate = NSPredicate(format: "item == %@", self.item)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
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

        title = item.title
        imagePickerSetup()
        
        //Rechtes Pluszeichen
        let addButton =  UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addPicture(_:)))
        let addImage = UIImage(named: "hatshairears0.png")!
        
        let addButton2 = UIBarButtonItem(image: addImage, style: .Plain, target: self, action: #selector(addPicture(_:)))
        
        
        navigationItem.setRightBarButtonItems([addButton, addButton2], animated: true)
    }

    //MARK: - Methoden
    func addPicture(sender:UIBarButtonItem){
        count = count + 1
        
        //Beginn
        let alertController = UIAlertController(title: "Foto", message: "Machen Sie ein Foto oder wählen eine Foto aus ihrem Album aus", preferredStyle: .ActionSheet)
        
        let makePhoto = UIAlertAction(title: "Foto", style: .Default) { (action) in
            print("Mache ein Foto")
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let choosePhoto = UIAlertAction(title: "Foto wählen", style: .Default) { (action) in
            print("Wähle ein Photo")
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(makePhoto)
        alertController.addAction(choosePhoto)
        alertController.addAction(cancelAction)
        
        //Ende
        //auskommentiert für UIAlertControllerTest
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section])?.numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kPictureCell, forIndexPath: indexPath) as! PictureCell
        cell.picture = fetchedResultsController.objectAtIndexPath(indexPath) as! Picture
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let picture = fetchedResultsController.objectAtIndexPath(indexPath) as! Picture
            picture.deleteRecord()
        }
    }
}

//Version Swift 2.0
extension PictureTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerSetup() {
        
        imagePicker.delegate = self
            //imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        //imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // create NSData from UIImage
        if let imageData = UIImageJPEGRepresentation(image, 1) {
            Picture.createPictureForItem(item, withImageData: imageData, withID: count)
        }else{
            print("error jpg")
        }
    
    }

}

extension PictureTVC: NSFetchedResultsControllerDelegate {
    
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


