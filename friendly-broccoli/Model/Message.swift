//
//  Message.swift
//  EASY
//
//  Created by App Knit on 19/10/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


enum MESSAGE_TYPE:String{
    case text = "text"
    case image = "image"
    case video = "video"
}



//=======================
//MARK:- MESSAGE
//=======================
class Message{
    
    //MARK: Properties
    var roomRef: String
    var message: Any
    var messageType: String
    var userId: String
    var timestamp: Double
    var sender: Bool
    var senderName: String
    
    init(roomRef:String,message:Any,messageType:String,userId:String,timestamp:Double,sender:Bool,senderName:String){
        self.roomRef = roomRef
        self.message = message
        self.messageType = messageType
        self.userId = userId
        self.timestamp = timestamp
        self.sender = sender
        self.senderName = senderName
        
    }
    
    //MARK:- Download Last Message
    func downloadLastMessage(roomId: String, completion: @escaping () -> Swift.Void){
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        db.collection("MESSAGES").whereField("roomRef", isEqualTo: roomId)
            .order(by: "timestamp", descending: true).limit(to: 1)
            .addSnapshotListener() { (querySnapshot, err) in
                guard let snapshot = querySnapshot else {return}
                print(snapshot)
                snapshot.documentChanges.forEach { (DOC) in
                    //if added
                  if DOC.type == .added{
                    
                    let message = FireMessage(dictionary: DOC.document.data())
                    self.roomRef = message!.roomRef
                    self.message = message!.message
                    self.messageType = message!.messageType
                    self.userId = message!.userId
                    self.timestamp = message!.timestamp
                    self.sender = message!.sender
                    self.senderName = message!.senderName
                    if message!.userId != AppModel.shared.loggedInUser.id{
                        if AppConstants.shouldPlaySound{
                           AudioService().playSound()
                        }
                    }
                    completion()
                }
            }
        }
    }
    
}


