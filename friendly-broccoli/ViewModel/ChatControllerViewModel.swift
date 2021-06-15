//
//  ChatControllerViewModel.swift
//  EASY
//
//  Created by MACBOOK on 30/01/20.
//  Copyright © 2020 Rohit Saini. All rights reserved.
//

import Foundation
import UIKit

class ChatControllerViewModel{
    private var MessagesDataSource:[Message] = [Message]()
    
     //MARK:- downloadMessages
    func downloadMessages(roomRef: String,_ completion: @escaping() -> Void){
           User.downloadMessages(roomRef: roomRef) { [weak self](msg) in
               self?.MessagesDataSource.append(msg)
               completion()
           }
       }
    func messageCount() -> Int{
           return MessagesDataSource.count
    }
       
    func message(index: Int) -> Message{
           let msg = MessagesDataSource[index]
           return msg
    }
}
