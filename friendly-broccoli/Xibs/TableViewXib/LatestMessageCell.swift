//
//  LatestMessageCell.swift
//  EASY
//
//  Created by Rohit Saini on 20/11/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class LatestMessageCell: UITableViewCell {

    @IBOutlet weak var onlineColorStatusView: UIView!
    @IBOutlet weak var onlineBackView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var lastestMsgLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    var conversation: Conversation!{
        didSet{
            profilePic.downloadCachedImage(placeholder: "user_avatar", urlString: conversation.user.profilePicLink)
            lastestMsgLbl.text = conversation.lastMessage.message as? String
            usernameLbl.text = conversation.user.name
            dateLbl.text = getReadableDate(timeStamp: conversation.lastMessage.timestamp)
            if conversation.user.isOnline{
                onlineColorStatusView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            }
            else{
                onlineColorStatusView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- configUI
    private func configUI(){
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        profilePic.layer.masksToBounds = true
        onlineBackView.layer.cornerRadius = onlineBackView.frame.height / 2
        onlineBackView.layer.masksToBounds = true
        onlineColorStatusView.layer.cornerRadius = onlineColorStatusView.frame.height / 2
        onlineColorStatusView.layer.masksToBounds = true
    }
}
