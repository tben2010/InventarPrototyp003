//
//  StartVC.swift
//  InventarPrototyp003
//
//  Created by tben on 26.02.16|KW8.
//  Copyright © 2016 tben. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var inventoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        inventoryLabel.text = NSLocalizedString("StartScreen", value: "Inventory", comment: "Title from Start Screnn")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
