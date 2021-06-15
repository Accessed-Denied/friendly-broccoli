//
//  Conversation.swift
//  EASY
//
//  Created by Rohit Saini on 26/10/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import Foundation
import Firebase

class Conversation {
    
    //MARK: Properties
    var user: FirebaseUser
    var lastMessage: Message
    
    //MARK: Methods
    class func listConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = AppModel.shared.loggedInUser?.id {
            print(currentUserID)
            var conversations = [Conversation]()
            let settings = FirestoreSettings()
//            settings.areTimestampsInSnapshotsEnabled = true
            Firestore.firestore().settings = settings
            // [END setup]
            db = Firestore.firestore()
            db.collection("ROOM_TO_USER_MAPPING").whereField("userId", isEqualTo: currentUserID)
                .addSnapshotListener() { (querySnapshot, err) in
                    guard let snapshot = querySnapshot else {return}
                    snapshot.documentChanges.forEach { (DOC) in
                        //if added
                        if DOC.type == .added{
                            print(DOC.document.data())
                            let UpdatedDocument = FirestoreRoomToUserMapping(dictionary: DOC.document.data())
                            User.downloadUserInfo(userId: UpdatedDocument?.receiptUserId ?? "") { (user) in
                                let emptyMessage = Message(roomRef: "gh", message: "Test", messageType: "text", userId: "sda", timestamp: 0, sender: false, senderName: "")
                                let conversation = Conversation(user: user, lastMessage: emptyMessage)
                                conversations.append(conversation)
                                conversation.lastMessage.downloadLastMessage(roomId: UpdatedDocument?.roomId ?? "") {
                                    completion(conversations)
                                }
                            }
                        }
                       
                    }
            }
        }
    }
    
    //MARK: Inits
    init(user: FirebaseUser, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
    

    
}
