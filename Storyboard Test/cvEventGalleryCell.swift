//
//  cvEventGalleryCell.swift
//  Storyboard Test
//
//  Created by Neil Oliver on 23/04/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import UIKit

class cvEventGalleryCell: UICollectionViewCell {
    
    @IBOutlet var imgEventGalleryPhoto: UIImageView!
    @IBOutlet var CommentLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

}
