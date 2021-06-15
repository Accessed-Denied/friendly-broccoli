//
//  ImageChatCell.swift
//  EASY
//
//  Created by Rohit Saini on 28/10/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class ImageChatCell: UITableViewCell {
    
    //CHAT Cell OUTLETS
    @IBOutlet weak var chatBackgroundView: UIView!
    @IBOutlet weak var timeDateLbl: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var ChatPicture: UIImageView!
    
    
    
      
      var MSG: Message!{
          didSet{
              if MSG.sender{
                ChatPicture.downloadCachedImage(placeholder: "", urlString: MSG.message as! String)
                  userName.text = MSG.senderName
                  timeDateLbl.text = getDifferenceFromCurrentTimeInHourInDays(MSG.timestamp)
                  UpdateChatCellAlignment(type: ChatBubbleType.outgoing)
              }
              else{
                  ChatPicture.downloadCachedImage(placeholder: "user_avatar", urlString: MSG.message as! String)
                  userName.text = MSG.senderName
                  timeDateLbl.text = getDifferenceFromCurrentTimeInHourInDays(MSG.timestamp)
                  UpdateChatCellAlignment(type: ChatBubbleType.incoming)
              }
          }
      }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        SetChatCellAppearence()
    }
    
    //MARK:- SetChatCellAppearence
         private func SetChatCellAppearence(){
             ChatPicture.layer.cornerRadius = 20
         }
         
         
         //MARK:- UpdateChatCellAlignment
         func UpdateChatCellAlignment(type: ChatBubbleType){
             if type == .incoming{
                 chatStackView.alignment = .leading
             }
             else if type == .outgoing{
                 chatStackView.alignment = .trailing
             }
         }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
