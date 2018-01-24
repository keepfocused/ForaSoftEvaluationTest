//
//  AlbumCell.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 23.01.18.
//  Copyright © 2018 @Danil. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    var albumName:String = ""
    var artistName:String = ""
    var albumImage:UIImage? = nil
    
    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var artisNameLabel: UILabel!
}
