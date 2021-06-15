//
//  PostDetailsMediaCell.swift
//  EASY
//
//  Created by Rohit Saini on 26/11/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class PostDetailsMediaCell: UITableViewCell {

    @IBOutlet weak var postedByUserPic: UIImageView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var postByUsername: UILabel!
    @IBOutlet weak var postPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        // Initialization code
    }
    
    private func configUI(){
        postedByUserPic.layer.cornerRadius = postedByUserPic.frame.height / 2
        postedByUserPic.layer.masksToBounds = true
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
