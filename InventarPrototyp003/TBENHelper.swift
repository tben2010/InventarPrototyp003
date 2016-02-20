//
//  TBENHelper.swift
//  InventoryPrototyp002
//
//  Created by tben on 05.02.16|KW5.
//  Copyright © 2016 tben. All rights reserved.
//

import UIKit

class TBENHelper {
    
    static func delayOnMainQueue(delay:NSTimeInterval, closure:() -> Void) {
        TBENHelper.delayOnQueue(delay, queue: dispatch_get_main_queue(), closure: closure)
    }
    
    static func delayOnQueue(delay:NSTimeInterval, queue:dispatch_queue_t, closure:() -> Void ) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, queue, closure)
    }
    
    static func singleTextFieldDialogWithTitle(title:String, message:String, placeholder:String, textFieldValue:String, ok:String, cancel:String, okClosure:(text:String) -> Void) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        controller.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = placeholder
            textField.text = textFieldValue
        }
        
        let okAction = UIAlertAction(title: ok, style: .Default) { (action) -> Void in
            if let textField = controller.textFields?.first where !textField.text!.isEmpty{
                okClosure(text: textField.text!)
            }
        }
        
        let cancelAction = UIAlertAction(title: cancel, style: .Cancel, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        return controller
    }
    
}
