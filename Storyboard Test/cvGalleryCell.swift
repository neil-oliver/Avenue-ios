//
//  HomeCollectionViewCell.swift
//  CollectionView
//
//  Created by Michael Babiy on 6/3/14.
//  Copyright (c) 2014 Michael Babiy. All rights reserved.
//

import UIKit

class cvGalleryCell: UICollectionViewCell {

@IBOutlet var imgGalleryPhoto: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
