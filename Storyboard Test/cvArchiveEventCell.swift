//
//  cvArchiveEventCell.swift
//  Avenue
//
//  Created by Neil Oliver on 20/05/2015.
//  Copyright (c) 2015 Neil Oliver. All rights reserved.
//

import Foundation
import UIKit

class cvArchiveEventCell: UICollectionViewCell {
    
    @IBOutlet var imgBox: UIImageView!
    @IBOutlet var CommentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    
}