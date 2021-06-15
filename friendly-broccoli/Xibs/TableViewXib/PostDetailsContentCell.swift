//
//  PostDetailsContentCell.swift
//  EASY
//
//  Created by Rohit Saini on 26/11/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class PostDetailsContentCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
