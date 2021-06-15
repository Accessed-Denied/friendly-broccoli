//
//  AppModel.swift
//  ADEQ
//
//  Created by Rohit Saini on 21/02/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit


//MARK- DocumentSerializable
protocol DocumentSerializable {
    init?(dictionary:[String: Any])
}

class AppModel: NSObject {
    static let shared = AppModel()
    var loggedInUser: FirebaseUser!
}


//=======================
//MARK:- FireMessage
//=======================
struct FireMessage{
    
    //MARK: Properties
    let roomRef: String
    let message: Any
    let messageType: String
    let userId: String
    let timestamp: Double
    let sender: Bool
    let senderName: String
    
    
    
    var dictionary: [String: Any]{
        return[
            "roomRef":roomRef,
            "message":message,
            "messageType":messageType,
            "userId":userId,
            "timestamp":timestamp,
            "sender":sender,
            "senderName":senderName
        ]
    }
}

extension FireMessage: DocumentSerializable{
    init?(dictionary: [String : Any]) {
       guard let roomRef = dictionary["roomRef"] as? String,
        let message = dictionary["message"],
        let messageType = dictionary["messageType"] as? String,
        let timestamp = dictionary["timestamp"] as? Double,
        let userId = dictionary["userId"] as? String,
        let sender = dictionary["sender"] as? Bool,
        let senderName = dictionary["senderName"] as? String else{return nil}
        self.init(roomRef:roomRef,message:message,messageType:messageType,userId:userId,timestamp:timestamp,sender:sender,senderName:senderName)
    }
}


//MARK:- FirebaseUser
struct FirebaseUser:Codable{
    let id: String
    let name: String
    let email: String
    let profilePicLink: String
    let phoneNumber: String
    let isTyping:Bool
    var isOnline:Bool
    
    
    var dictionary: [String: Any]{
        return[
            "id":id,
            "name":name,
            "email":email,
            "profilePicLink":profilePicLink,
            "phoneNumber":phoneNumber,
            "isTyping":isTyping,
            "isOnline":isOnline
        ]
    }
}


extension FirebaseUser: DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let email = dictionary["email"] as? String,
            let profilePicLink = dictionary["profilePicLink"] as? String,
            let phoneNumber = dictionary["phoneNumber"] as? String,
            let isTyping = dictionary["isTyping"] as? Bool,
            let isOnline = dictionary["isOnline"] as? Bool else{return nil}
        self.init(id: id,name: name,email:email,profilePicLink:profilePicLink,phoneNumber:phoneNumber,isTyping:isTyping,isOnline:isOnline)
    }
}




//MARK:- FirebasePost
struct FirebasePost{
    let userId: String
    let postId: String
    let username: String
    let postType: String
    let categoryName: String
    let postText: String
    let mediaType: String
    let postUrl:String
    let creatorProfilePic:String
    let timestamp: Double
    let videoThumbnail: String
    
    var dictionary: [String: Any]{
        return[
            "userId":userId,
            "postId":postId,
            "username":username,
            "postType":postType,
            "categoryName":categoryName,
            "postText":postText,
            "mediaType":mediaType,
            "postUrl":postUrl,
            "creatorProfilePic":creatorProfilePic,
            "timestamp":timestamp,
            "videoThumbnail":videoThumbnail
        ]
    }
}

extension FirebasePost: DocumentSerializable{
    init?(dictionary: [String : Any]) {
       guard let userId = dictionary["userId"] as? String,
             let postId = dictionary["postId"] as? String,
             let username = dictionary["username"] as? String,
             let postType = dictionary["postType"] as? String,
             let categoryName = dictionary["categoryName"] as? String,
             let postText = dictionary["postText"] as? String,
             let mediaType = dictionary["mediaType"] as? String,
             let creatorProfilePic = dictionary["creatorProfilePic"] as? String,
             let postUrl = dictionary["postUrl"] as? String,
             let videoThumbnail = dictionary["videoThumbnail"] as? String,
             let timestamp = dictionary["timestamp"] as? Double else{return nil}
        self.init(userId: userId,postId: postId,username:username,postType:postType,categoryName:categoryName,postText:postText,mediaType:mediaType,postUrl:postUrl,creatorProfilePic:creatorProfilePic,timestamp:timestamp,videoThumbnail:videoThumbnail)
    }
}



//MARK:- FirestoreRoomToUserMapping
struct FirestoreRoomToUserMapping{
    let userId: String
    let roomId: String
    let receiptUserId: String
    
    var dictionary: [String: Any]{
        return[
            "userId":userId,
            "roomId":roomId,
            "receiptUserId":receiptUserId
        ]
    }
}

extension FirestoreRoomToUserMapping: DocumentSerializable{
    init?(dictionary: [String : Any]) {
       guard let userId = dictionary["userId"] as? String,
             let roomId = dictionary["roomId"] as? String,
             let receiptUserId = dictionary["receiptUserId"] as? String else{return nil}
        self.init(userId: userId,roomId: roomId,receiptUserId:receiptUserId)
    }
}

