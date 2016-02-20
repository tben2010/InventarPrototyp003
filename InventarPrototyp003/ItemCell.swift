//
//  ItemCell.swift
//  InventoryPrototyp002
//
//  Created by tben on 05.02.16|KW5.
//  Copyright © 2016 tben. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    var item:Item!{
        didSet{
            textLabel?.text = item.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
