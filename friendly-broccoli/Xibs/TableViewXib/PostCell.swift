//
//  PostCell.swift
//  EASY
//
//  Created by Rohit Saini on 02/10/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var createdOnLbl: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var postContentLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        // Initialization code
    }
    
    private func configUI(){
        postImageView.layer.cornerRadius =  10
        if #available(iOS 11.0, *) {
            postImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        overlayView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            overlayView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        userBtn.layer.cornerRadius =  userBtn.frame.height / 2
        userBtn.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
