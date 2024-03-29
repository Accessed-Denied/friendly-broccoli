//
//  User.swift
//  EASY
//
//  Created by Rohit Saini on 14/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

typealias Loginhandler = (_ msg:String?) -> Void //closure
var db: Firestore!


  //MARK:- POSTMEDIA
enum POSTMEDIA{
    case IMAGE
    case VIDEO
}

  //MARK:- ROOMTYPE
enum ROOM_TYPE: String{
    case peer = "peer"
    case group = "group"
}



//=======================
//MARK:- USER
//=======================
class User: NSObject {
    
    //MARK: Properties
    var name: String
    var email: String
    let id: String
    var profilePic: UIImage
    
    
    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: UIImage,latitude: Any,longitude: Any) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
    
    
    struct loginErrorCode {
        static let INVALID_EMAIL = "Invalid Email"
        static let UNVERIFIED_PHONENUMBER = "Mobile number is not Verified"
        static let WRONG_PASSWORD = "Wrong Password"
        static let PROBLEM_CONNECTING = "Problem Connecting to Databases "
        static let USER_NOT_FOUND = "User Not Found"
        static let EMAIL_ALREADY_USED = "Email Already used Try Another One"
        static let WEAK_PASSWORD = "Password should be alteast 6 characters long"
        static let SOMETHING_WENT_WRONG = "Something went wrong try Again"
        static let INVALID_CUSTOM_TOKEN = "Validation error with the custom token."
        static let CUSTOM_TOKEN_MISMATCH = "Service account and the API key belong to different projects."
        static let INVALID_CREDENTIAL = "Supplied credential is invalid. This could happen if it has expired or it is malformed."
        static let USER_DISABLE = "User's account is disabled."
        static let OPERATION_NOT_ALLOWED = "Email and password accounts are not enabled. Enable them in the Auth section of the Firebase console."
        static let TOO_MANY_REQUESTS = "Request has been blocked after an abnormal number of requests have been made from the caller device to the Firebase Authentication servers. Retry again after some time."
        static let ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL = "This account is already present with different credential"
        static let REQUIRES_RECENT_LOGIN = "Updating a user’s email is a security sensitive operation that requires a recent login from the user. This error indicates the user has not signed in recently enough. To resolve, reauthenticate the user by invoking reauthenticateWithCredential:completion: on FIRUser."
        static let PROVIDER_ALREADY_LINKED  = "Attempt to link a provider of a type already linked to this account."
        static let NO_SUCH_PROVIDER = "Attempt to unlink a provider that is not linked to the account."
        static let INVALID_USER_TOKEN = "The signed-in user's refresh token, that holds session information, is invalid. You must prompt the user to sign in again on this device."
        static let NETWORK_ERROR = "Network error occurred during the operation"
        static let USER_TOKEN_EXPIRED = "The current user’s token has expired, for example, the user may have changed account password on another device. You must prompt the user to sign in again on this device."
        static let INVALID_API_KEY = "Application has been configured with an invalid API key."
        static let USER_MISMATCH = "An attempt was made to reauthenticate with a user which is not the current user."
        static let CREDENTIAL_ALREADY_IN_USE = "An attempt to link with a credential that has already been linked with a different Firebase account."
        static let APP_NOT_AUTHORIZED = "App is not authorized to use Firebase Authentication with the provided API Key. go to the Google API Console and check under the credentials tab that the API key you are using has your application’s bundle ID whitelisted."
        static let EXPIRED_ACTION_CODE = "Action code is Expired"
        static let INVALID_ACTION_CODE = "Action code is Invalid"
        static let INVALID_MESSAGE_PAYLOAD = "Message payload is not valid"
        static let INVALID_SENDER = "Sender is not valid"
        static let INVALID_RECIPIENT_EMAIL = "Recipient mail is not valid"
        static let KEYCHAIN_ERROR = "Error in keychain"
        static let INTERNAL_ERROR = "Some internal Error"
        
    }//errorCodes
    
    //=============================
    //MARK:- handleErrors
    //=============================
    class func handleErrors(err: NSError ,loginHandler:Loginhandler){
        
        if let errCode = AuthErrorCode(rawValue: err.code){
            
            switch errCode{
            case .userNotFound:
                loginHandler(loginErrorCode.USER_NOT_FOUND)
                break
            case .invalidEmail:
                loginHandler(loginErrorCode.INVALID_EMAIL)
                break
            case .invalidCustomToken:
                loginHandler(loginErrorCode.INVALID_CUSTOM_TOKEN)
                break
            case .customTokenMismatch:
                loginHandler(loginErrorCode.CUSTOM_TOKEN_MISMATCH)
                break
            case .invalidCredential:
                loginHandler(loginErrorCode.INVALID_CREDENTIAL)
                break
            case .userDisabled:
                loginHandler(loginErrorCode.USER_DISABLE)
                break
            case .operationNotAllowed:
                loginHandler(loginErrorCode.OPERATION_NOT_ALLOWED)
                break
            case .emailAlreadyInUse:
                loginHandler(loginErrorCode.EMAIL_ALREADY_USED)
                break
            case .wrongPassword:
                loginHandler(loginErrorCode.WRONG_PASSWORD)
                break
            case .tooManyRequests:
                loginHandler(loginErrorCode.TOO_MANY_REQUESTS)
                break
            case .accountExistsWithDifferentCredential:
                loginHandler(loginErrorCode.ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL)
                break
            case .requiresRecentLogin:
                loginHandler(loginErrorCode.REQUIRES_RECENT_LOGIN)
                break
            case .providerAlreadyLinked:
                loginHandler(loginErrorCode.PROVIDER_ALREADY_LINKED)
                break
            case .noSuchProvider:
                loginHandler(loginErrorCode.NO_SUCH_PROVIDER)
                break
            case .invalidUserToken:
                loginHandler(loginErrorCode.INVALID_USER_TOKEN)
                break
            case .networkError:
                loginHandler(loginErrorCode.NETWORK_ERROR)
                break
            case .userTokenExpired:
                loginHandler(loginErrorCode.USER_TOKEN_EXPIRED)
                break
            case .invalidAPIKey:
                loginHandler(loginErrorCode.INVALID_API_KEY)
                break
            case .userMismatch:
                loginHandler(loginErrorCode.USER_MISMATCH)
                break
            case .credentialAlreadyInUse:
                loginHandler(loginErrorCode.CREDENTIAL_ALREADY_IN_USE)
                break
            case .weakPassword:
                loginHandler(loginErrorCode.WEAK_PASSWORD)
                break
            case .appNotAuthorized:
                loginHandler(loginErrorCode.APP_NOT_AUTHORIZED)
                break
            case .expiredActionCode:
                loginHandler(loginErrorCode.EXPIRED_ACTION_CODE)
                break
            case .invalidActionCode:
                loginHandler(loginErrorCode.INVALID_ACTION_CODE)
                break
            case .invalidMessagePayload:
                loginHandler(loginErrorCode.INVALID_MESSAGE_PAYLOAD)
                break
            case .invalidSender:
                loginHandler(loginErrorCode.INVALID_SENDER)
                break
            case .invalidRecipientEmail:
                loginHandler(loginErrorCode.INVALID_RECIPIENT_EMAIL)
                break
            case .keychainError:
                loginHandler(loginErrorCode.KEYCHAIN_ERROR)
                break
            case .internalError:
                loginHandler(loginErrorCode.INTERNAL_ERROR)
                break
            default:
                loginHandler(loginErrorCode.SOMETHING_WENT_WRONG)
                break
            }
            
        }
    }
    //END error handler
    
    
    //====================================
    //MARK:- registerUser
    //====================================
    class func registerUser(withName:String,email:String,password:String,phoneNumber: String ,profilePic:UIImage,loginHandler: Loginhandler?){
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        showLoader()
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil{
                
                user?.user.sendEmailVerification(completion: { (error) in
                    if error == nil{
                        let storageRef = Storage.storage().reference().child("usersProfilePics").child("\((user?.user.uid)!).jpg")
                        let imageData = compressImage(image: profilePic)// Compress Image to speed up the api
                        storageRef.putData(imageData, metadata: nil, completion: { (metadata, err) in
                            if err == nil {
                                storageRef.downloadURL(completion: { (url, error) in
                                    if error == nil{
                                        guard let path = url?.absoluteString else{
                                            return
                                        }
                                        let credentials: [String: Any] = ["id":(user?.user.uid)!,"name": withName, "email": email, "profilePicLink": path,"phoneNumber":phoneNumber,"isTyping":false,"isOnline":false]
                                        var ref: DocumentReference? = nil
                                        
                                        ref = db.collection("USERS").document((user?.user.uid)!)
                                        ref?.setData(credentials)
                                        { error in
                                            if let err = error {
                                                print("Error updating document: \(err)")
                                                removeLoader()
                                                self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                                                
                                            } else {
                                                removeLoader()
                                                loginHandler!(nil)
                                                print("Document successfully updated")
                                            }
                                            
                                            
                                        }
                                    }else{
                                        removeLoader()
                                        self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                                    }
                                })
                                
                            }
                        })
                    }
                    else{
                        removeLoader()
                        
                        self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                    }
                })
                
            }
            else{
                removeLoader()
                
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                
            }
            
        }
    }
    //END Register User
    
    
    //==============================
    //MARK:- loginUser
    //==============================
    class func loginUser(email:String,password: String, loginHandler: Loginhandler?) {
        showLoader()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                guard let status = Auth.auth().currentUser?.isEmailVerified else{
                    return
                }
                if status == true{
                    downloadUserInfo(userId: (user?.user.uid)!) { (userInfo) in
                        let encoder = JSONEncoder()
                        if let encoded = try? encoder.encode(userInfo) {
                            let defaults = UserDefaults.standard
                            defaults.set(encoded, forKey: "currentUser")
                        }
                        UserDefaults.standard.set(user?.user.uid, forKey: "userId")
                        AppModel.shared.loggedInUser = userInfo
                        removeLoader()
                        loginHandler!(nil)
                    }
                    
                }else{
                    removeLoader()
                    loginHandler!("Email is not verified")
                }
                
                
            } else {
                removeLoader()
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
            }
        }
    }
    //END Login User
    
  
    
    //============================
    //MARK:- Download User Info
    //============================
    
    class func downloadUserInfo(userId: String, completion: @escaping (FirebaseUser) -> Swift.Void) {
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        print(userId)
        db.collection("USERS").document(userId)
            .getDocument { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if let data = querySnapshot?.data(){
                        print(data)
                        if let user = FirebaseUser(dictionary: data){
                        completion(user)
                        }
                    }
                }
        }
    }//Get User Info
    
    
    
      //MARK:- CreatePost
    class func CreatePost(userId:String,username:String,postType:String,categoryName: String ,postText:String,mediaType: POSTMEDIA,postMediaData:Data,videoUrl: URL?,loginHandler: Loginhandler?){
           // [START setup]
           let settings = FirestoreSettings()
//           settings.areTimestampsInSnapshotsEnabled = true
           Firestore.firestore().settings = settings
           // [END setup]
           db = Firestore.firestore()
        showLoader()
        if mediaType == .IMAGE{
            let storageRef = Storage.storage().reference().child("POSTS_IMAGES").child("\(Date().timeIntervalSince1970).jpg")
            storageRef.putData(postMediaData, metadata: nil, completion: { (metadata, err) in
                if err == nil {
                    storageRef.downloadURL(completion: { (url, error) in
                        if error == nil{
                            guard let path = url?.absoluteString else{
                                return
                            }
                            var ref: DocumentReference? = nil
                            ref = db.collection("POSTS").document()
                            let postData: [String: Any] = ["userId": userId,"username": username, "postType": postType, "categoryName": categoryName,"postText":postText,"mediaType":"IMAGE","postUrl":path,"postId":(ref?.documentID)!,"timestamp":Date().timeIntervalSince1970,"creatorProfilePic":AppModel.shared.loggedInUser.profilePicLink,"videoThumbnail":""]
                            ref?.setData(postData)
                            { error in
                                if let err = error {
                                    print("Error updating document: \(err)")
                                    removeLoader()
                                    self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                                    
                                } else {
                                    removeLoader()
                                    loginHandler!(nil)
                                    print("Document successfully updated")
                                }
                                
                                
                            }
                        }else{
                            removeLoader()
                            self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                        }
                    })
                    
                }
            }).observe(.progress) { snapshot in
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                print("Uploading image: \(percentComplete.rounded())%")// NSProgress object
            }
        }
        else{
            let fileName = NSUUID().uuidString + ".mov"
            let storageRef = Storage.storage().reference().child("POSTS_VIDEOS").child(fileName)
            let imageStorageRef = Storage.storage().reference().child("POSTS_IMAGES").child("\(Date().timeIntervalSince1970).jpg")
            imageStorageRef.putData(postMediaData, metadata: nil, completion: { (metadata, err) in
                if err == nil {
                    imageStorageRef.downloadURL(completion: { (url, error) in
                        if error == nil{
                            guard let thumbnailUrl = url?.absoluteString else{
                                return
                            }
                            var movieData: Data?
                            do {
                                movieData = try Data(contentsOf: videoUrl!, options: Data.ReadingOptions.alwaysMapped)
                            } catch _ {
                                movieData = nil
                                return
                            }
                            storageRef.putData(movieData!, metadata: nil, completion: { (metadata, err) in
                            if err == nil {
                                    storageRef.downloadURL(completion: { (url, error) in
                                        if error == nil{
                                            guard let path = url?.absoluteString else{
                                                return
                                            }
                                            var ref: DocumentReference? = nil
                                            ref = db.collection("POSTS").document()
                                            let postData: [String: Any] = ["userId": userId,"username": username, "postType": postType, "categoryName": categoryName,"postText":postText,"mediaType":"VIDEO","postUrl":path,"postId":(ref?.documentID)!,"timestamp":Date().timeIntervalSince1970,"creatorProfilePic":AppModel.shared.loggedInUser.profilePicLink,"videoThumbnail":thumbnailUrl]
                                            
                                            ref?.setData(postData)
                                            { error in
                                                if let err = error {
                                                    print("Error updating document: \(err)")
                                                    removeLoader()
                                                    self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                                                    
                                                } else {
                                                    removeLoader()
                                                    loginHandler!(nil)
                                                    print("Document successfully updated")
                                                }
                                                
                                                
                                            }
                                        }else{
                                            removeLoader()
                                            self.handleErrors(err: error! as NSError, loginHandler: loginHandler!)
                                        }
                                    })
                                    
                                }
                                else{
                                    print("ERROR: \(String(describing: err))")
                                }
                            }).observe(.progress) { snapshot in
                                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                                    / Double(snapshot.progress!.totalUnitCount)
                                print("Uploading video: \(percentComplete.rounded())%")// NSProgress object
                            }
                        }
                    })
                }
            })
            
        }
    }
       //END
    
    
    //============================
    //MARK:- Show Post
    //============================
    class func showPosts(postType: String, completion: @escaping ([FirebasePost]) -> Swift.Void) {
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // [START get_multiple_all]
        var posts: [FirebasePost] = [FirebasePost]()
        db.collection("POSTS").whereField("postType", isEqualTo: postType).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                posts = querySnapshot!.documents.compactMap({FirebasePost(dictionary: $0.data())})
                completion(posts)
            }
        }
        // [END get_multiple_all]
    }//END
    
    
    
      //MARK:- realTimeUpdatedPosts
    class func realtimeUpdatedPosts(postType: String, completion: @escaping (FirebasePost) -> Swift.Void) {
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // [START get_multiple_all]
        db.collection("POSTS").whereField("postType", isEqualTo: postType).order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {return}
                snapshot.documentChanges.forEach { (diff) in
                    //if post added
                    if diff.type == .added{
                        if let post = FirebasePost(dictionary: diff.document.data()){
                         completion(post)
                        }
                    }
                }
        }
        // [END get_multiple_all]
    }//END
    
    
    //MARK:- sendMessage
    class func sendMessage(receiptUserId:String){
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        createRoom(roomType: .peer) { (roomId) in
            print("New Room Created Successfully with: \(roomId)")
            uploadMessage(roomRef: roomId, message: "Hello Testing", messageType: MESSAGE_TYPE.text) { (success) in
                if success{
                    print("Message Sent Successfully to: \(receiptUserId)")
                    RoomToUserMapping(roomId: roomId, receiptUserId: receiptUserId, roomType: .peer) { (success) in
                        if success{
                            print("RoomToUserMapping created successfully")
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK:- createRoom
    class func createRoom(roomType: ROOM_TYPE,completion: @escaping (String) -> Swift.Void){
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("ROOMS").document()
        let roomInfo:[String: Any] = ["type":roomType.rawValue,"timestamp":Date().timeIntervalSince1970]
        ref?.setData(roomInfo)
        { error in
            if let err = error {
                print("Error creting room document:\(err)")
            } else {
                completion(ref!.documentID)
            }
        }
    }
    
    
    //MARK:- RoomToUserMapping
    class func RoomToUserMapping(roomId: String,receiptUserId: String,roomType:ROOM_TYPE,completion: @escaping (Bool) -> Swift.Void){
        // [START setup]
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        var ref: DocumentReference? = nil
        let data1 = ["roomId":roomId,"userId":AppModel.shared.loggedInUser.id,"receiptUserId":receiptUserId,"roomType":roomType.rawValue]
        let data2 = ["roomId":roomId,"userId":receiptUserId,"receiptUserId":AppModel.shared.loggedInUser.id,"roomType":roomType.rawValue]
        ref = db.collection("ROOM_TO_USER_MAPPING").document()
        ref?.setData(data1)
        { error in
            if let err = error {
                print("Error creting RoomToUserMapping:\(err)")
            } else {
                ref = db.collection("ROOM_TO_USER_MAPPING").document()
                ref?.setData(data2)
                { error in
                    if let err = error {
                        print("Error creting RoomToUserMapping:\(err)")
                    } else {
                        
                        completion(true)
                    }
                }
            }
        }
        
    }
    
    
    //MARK:- uploadMessage
    class func uploadMessage(roomRef:String,message: Any,messageType:MESSAGE_TYPE,completion: @escaping (Bool) -> Swift.Void){
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        var ref: DocumentReference? = nil
        var messageInfo: [String: Any] = [String: Any]()
        if messageType == .text{
            messageInfo = ["roomRef":roomRef,"message":message,"messageType":messageType.rawValue,"userId":AppModel.shared.loggedInUser.id,"timestamp":Date().timeIntervalSince1970,"sender":true,"senderName": AppModel.shared.loggedInUser.name]
            ref = db.collection("MESSAGES").document()
            ref?.setData(messageInfo)
            { error in
                if let err = error {
                    print("Error in Message sending:\(err)")
                } else {
                    completion(true)
                }
            }
        }
        else if messageType == .image{
            let storageRef = Storage.storage().reference().child("ChatPictures").child("\(Date().timeIntervalSince1970).jpg")
            storageRef.putData(message as! Data, metadata: nil, completion: { (metadata, err) in
                if err == nil {
                    storageRef.downloadURL(completion: { (url, error) in
                        if error == nil{
                            guard let path = url?.absoluteString else{
                                return
                            }
                            messageInfo = ["roomRef":roomRef,"message":path,"messageType":messageType.rawValue,"userId":AppModel.shared.loggedInUser.id,"timestamp":Date().timeIntervalSince1970,"sender":true,"senderName": AppModel.shared.loggedInUser.name]
                            ref = db.collection("MESSAGES").document()
                            ref?.setData(messageInfo)
                            { error in
                                if let err = error {
                                    print("Error in Message sending:\(err)")
                                } else {
                                    completion(true)
                                }
                            }
                            
                        }else{
                           assertionFailure("Unable to generate imageUrl")
                        }
                    })
                }
            })
        }
        else if messageType == .video{
            messageInfo = ["roomRef":roomRef,"message":message,"messageType":messageType.rawValue,"userId":AppModel.shared.loggedInUser.id,"timestamp":Date().timeIntervalSince1970,"sender":true,"senderName": AppModel.shared.loggedInUser.name]
            ref = db.collection("MESSAGES").document()
            ref?.setData(messageInfo)
            { error in
                if let err = error {
                    print("Error in Message sending:\(err)")
                } else {
                    completion(true)
                }
            }
        }
        
        
    }
    
    
    //MARK:- downloadMessages
    class func downloadMessages(roomRef:String,completion: @escaping (Message) -> Swift.Void){
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        db.collection("MESSAGES").whereField("roomRef", isEqualTo: roomRef).order(by: "timestamp", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {return}
                snapshot.documentChanges.forEach { (diff) in
                    //if post added
                    if diff.type == .added{
                        let message = FireMessage(dictionary: diff.document.data())
                        let MSG = Message(roomRef: message!.roomRef, message: message!.message, messageType: message!.messageType, userId: message!.userId, timestamp: message!.timestamp, sender: message?.userId == AppModel.shared.loggedInUser.id ? true : false, senderName: message!.senderName)
                        completion(MSG)
                    }
                }
          }
     }
    
    
       //MARK:- observerTyping
       class func observerTyping(userId:String,completion: @escaping (Bool) -> Swift.Void){
           let settings = FirestoreSettings()
//           settings.areTimestampsInSnapshotsEnabled = true
           Firestore.firestore().settings = settings
           // [END setup]
           db = Firestore.firestore()
           db.collection("USERS").whereField("id", isEqualTo: userId)
               .addSnapshotListener { (querySnapshot, error) in
                   guard let snapshot = querySnapshot else {return}
                   snapshot.documentChanges.forEach { (user) in
                       //if post added
                       if user.type == .modified{
                        let modifiedUser = FirebaseUser(dictionary: user.document.data())
                        completion(modifiedUser!.isTyping)
                       }
                   }
             }
        }
    
    //MARK:- updateUserTyping
    class func updateUserTyping(userId:String,isTyping:Bool){
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        let updatedData = ["isTyping":isTyping]
        var ref: DocumentReference? = nil
        ref = db.collection("USERS").document(userId)
        ref?.updateData(updatedData)
        { error in
            if let err = error {
                print("Error in updating typing:\(err)")
            }
        }
        
    }
    
    
    //MARK:- updateUserTyping
    class func updateUserOnlineStatus(userId:String,isOnline:Bool){
        let settings = FirestoreSettings()
//        settings.areTimestampsInSnapshotsEnabled = true
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        let updatedData = ["isOnline":isOnline]
        var ref: DocumentReference? = nil
        ref = db.collection("USERS").document(userId)
        ref?.updateData(updatedData)
        { error in
            if let err = error {
                print("Error in updating online status:\(err)")
            }
        }
    }
    

     //MARK: Methods
     class func observeUserOnlineStatus(completion: @escaping (FirebaseUser) -> Swift.Void) {
         if let currentUserID = AppModel.shared.loggedInUser?.id {
             let settings = FirestoreSettings()
//             settings.areTimestampsInSnapshotsEnabled = true
             Firestore.firestore().settings = settings
             // [END setup]
            db = Firestore.firestore()
            db.collection("USERS")
                .addSnapshotListener() { (querySnapshot, err) in
                    guard let snapshot = querySnapshot else {return}
                    snapshot.documentChanges.forEach { (DOC) in
                        //if added
                        if DOC.type == .modified{
                            let updatedUser = FirebaseUser(dictionary: DOC.document.data())
                            if updatedUser?.id != currentUserID{
                                completion(updatedUser!)
                            }
                            
                        }
                    }
            }
        }
    }
    
}
//END USER
