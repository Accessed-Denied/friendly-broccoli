//
//  TextChatCell.swift
//  EASY
//
//  Created by Rohit Saini on 27/10/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class TextChatCell: UITableViewCell {
    
        
        
        //CHAT Cell OUTLETS
        @IBOutlet weak var chatBackgroundView: UIView!
        @IBOutlet weak var timeDateLbl: UILabel!
        @IBOutlet weak var userName: UILabel!
        @IBOutlet weak var chatStackView: UIStackView!
        @IBOutlet weak var chatText: UITextView!
        
        
        
        var MSG: Message!{
            didSet{
                if MSG.sender{
                    chatText.text = MSG.message as? String
                    userName.text = MSG.senderName
                    timeDateLbl.text = getDifferenceFromCurrentTimeInHourInDays(MSG.timestamp)
                    UpdateChatCellAlignment(type: ChatBubbleType.outgoing)
                }
                else{
                    chatText.text = MSG.message as? String
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
            chatBackgroundView.layer.cornerRadius = 20
        }
        
        
        //MARK:- UpdateChatCellAlignment
        func UpdateChatCellAlignment(type: ChatBubbleType){
            if type == .incoming{
                chatStackView.alignment = .leading
                chatText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                chatBackgroundView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
            else if type == .outgoing{
                chatStackView.alignment = .trailing
                chatText.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                chatBackgroundView.backgroundColor = #colorLiteral(red: 1, green: 0.4520469308, blue: 0.2609457374, alpha: 1)
            }
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
    }
