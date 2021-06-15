//
//  HomeCell.swift
//  EASY
//
//  Created by Rohit Saini on 20/11/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var postTitleLbl: UILabel!
    @IBOutlet weak var homePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        // Initialization code
    }
    private func configUI(){
        homePic.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            homePic.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        infoView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            infoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
    }

}
