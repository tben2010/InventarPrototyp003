//
//  PictureCell.swift
//  InventoryPrototyp002
//
//  Created by tben on 05.02.16|KW5.
//  Copyright © 2016 tben. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {
    
    var picture:Picture!{
        didSet{
            let size = CGSizeMake(120, 75)
            if picture.picture != nil {
                let image = UIImage(data: picture.picture!)
                imageOutlet.image = image
                imageOutlet.image = imageResize(imageOutlet.image!,sizeChange: size)
            }
        }
    }

    //MARK: - Outlets
    @IBOutlet weak var imageOutlet: UIImageView!
    
    
    //MARK: - Methoden
    func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
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
