//
//  AlbumDetailCell.swift
//  ForaSoftEvaluationTest
//
//  Created by Danil on 29.01.18.
//  Copyright © 2018 @Danil. All rights reserved.
//

import UIKit

class AlbumDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var genreLabelOutlet: UILabel!
    @IBOutlet weak var priceLabelOutlet: UILabel!
    @IBOutlet weak var tracksCountLabelOutlet: UILabel!
}
