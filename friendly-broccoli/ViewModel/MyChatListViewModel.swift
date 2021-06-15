//
//  MyChatListViewModel.swift
//  EASY
//
//  Created by MACBOOK on 29/01/20.
//  Copyright © 2020 Rohit Saini. All rights reserved.
//

import Foundation
import UIKit



class MyChatListViewModel{
    private var ChatDataSource:[Conversation] = [Conversation]()
    //typealias MyChatListCallback = (_ completion: ) -> Void)
    func fetchChatUserList(_ completion: @escaping() -> Void){
        Conversation.listConversations { [weak self](users) in
            self?.ChatDataSource = users
            completion()
        }
    }
    func userCount() -> Int{
           return ChatDataSource.count
       }
       
    func user(index: Int) -> Conversation{
           let conversation = ChatDataSource[index]
           return conversation
    }
    
    func updateUserOnlineStatus(_ completion: @escaping() -> Void){
        User.observeUserOnlineStatus { [weak self](user) in
            if let row = self?.ChatDataSource.firstIndex(where: {$0.lastMessage.userId == user.id}) {
                self?.ChatDataSource[row].user.isOnline = user.isOnline
                completion()
            }
        }
    }
}
