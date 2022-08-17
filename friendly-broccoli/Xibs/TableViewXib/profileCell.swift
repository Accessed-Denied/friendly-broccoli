//
//  profileCell.swift
//  GolfApp
//
//  Created by MACBOOK on 17/12/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class profileCell: UITableViewCell {

    @IBOutlet weak var nextArrowImage: UIImageView!
    @IBOutlet weak var listTextLbl: UILabel!
    @IBOutlet weak var listImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
