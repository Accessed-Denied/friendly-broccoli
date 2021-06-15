//
//  ChatController.swift
//  EASY
//
//  Created by Rohit Saini on 18/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit
import AVFoundation
import GrowingTextView
import MobileCoreServices

class ChatController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GrowingTextViewDelegate {
    @IBOutlet weak var sendBtn: UIButton!
    

    
 
    @IBOutlet weak var typingLbl: UILabel!
    @IBOutlet weak var addAttachmentBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var navBarView: View!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextView: GrowingTextView!
    var lastContentOffset: CGFloat = 0
    var typeTimer: Timer!

     private let refreshControl = UIRefreshControl()
    var ChatControllerVM: ChatControllerViewModel = ChatControllerViewModel()
    var roomRef: String = ""
    var userId: String = ""
    var username: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    private func configUI(){
        headerView.layer.cornerRadius = 15
        headerView.layer.masksToBounds = true
        headerView.alpha = 0.8
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:16/255, green:27/255, blue:57/255, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "loading...")
        tableView.register(UINib(nibName: "TextChatCell", bundle: nil), forCellReuseIdentifier: "TextChatCell")
        tableView.register(UINib(nibName: "ImageChatCell", bundle: nil), forCellReuseIdentifier: "ImageChatCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        //textView
        chatTextView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        chatTextView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        ChatControllerVM.downloadMessages(roomRef: roomRef) {[weak self] in
            guard let self = self else{return}
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }
        ObserverUserTyping()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }
    
   
    //MARK:- Typing...
    func textViewDidChange(_ textView: UITextView) {
        typeTimer?.invalidate()
        typeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(textFieldStopEditing(sender:)), userInfo: nil, repeats: false)
        print("Start typing...")
        User.updateUserTyping(userId: AppModel.shared.loggedInUser.id, isTyping: true)
    }
    
    @objc func textFieldStopEditing(sender: Timer) {
       print("Stopped typing...")
       User.updateUserTyping(userId: AppModel.shared.loggedInUser.id, isTyping: false)
    }
    
   
    

    
//    //MARK:- downloadMessages
//    private func downloadMessages(){
//        User.downloadMessages(roomRef: roomRef) { [weak self](msg) in
//            self?.chatMessages.append(msg)
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//                self?.scrollToBottom()
//            }
//        }
//    }
    
    //MARK:- Observer Typing...
    private func ObserverUserTyping(){
        User.observerTyping(userId: userId) { [weak self](typing) in
            if typing{
                self?.typingLbl.text = "\(self?.username ?? "") is typing..."
                
            }
            else{
                self?.typingLbl.text = ""
                
            }
        }
    }
    
    //MARK:- scrollToBottom
    func scrollToBottom() {
        if ChatControllerVM.messageCount() > 0 {
            self.tableView.scrollToRow(at: IndexPath.init(row: ChatControllerVM.messageCount() - 1, section: 0), at: .bottom, animated: false)
        }
    }
        
    
    //MARK:- refreshData
    @objc private func refreshData(_ sender: Any){
        refreshControl.endRefreshing()
            
    }
    @IBAction func clickToSendMessage(_ sender: UIButton) {
        if self.chatTextView.text == ""{
            return
        }
        
        User.uploadMessage(roomRef: roomRef, message: chatTextView.text, messageType: MESSAGE_TYPE.text) { (success) in
            print("Chat Text Sent Successfully!")
        }
        self.chatTextView.text = ""
        
    }
    
    @IBAction func clickToAddAttachments(_ sender: UIButton) {
        uploadImage()
    }
    
    
    @IBAction func clickToBackBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NOTIFICATIONS.PlaySound, object: ["data":true])
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Upload Image
         func uploadImage()
        {
            let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                print("Cancel")
            }
            actionSheet.addAction(cancelButton)
            
            let cameraButton = UIAlertAction(title: "Camera", style: .default)
            { _ in
                print("Camera")
                self.onCaptureImageThroughCamera()
            }
            
            
            actionSheet.addAction(cameraButton)
            
            
            
            let galleryButton = UIAlertAction(title: "Gallery", style: .default)
            { _ in
                print("Gallery")
                self.onCaptureImageThroughGallery()
            }
            actionSheet.addAction(galleryButton)
            
            
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            actionSheet.popoverPresentationController?.permittedArrowDirections = []
            actionSheet.view.tintColor = colorFromHex(hex: "#101B39")
            self.present(actionSheet, animated: true, completion: nil)
        }
        
        @objc open func onCaptureImageThroughCamera()
        {
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                //displayToast("Your device has no camera")
                
            }
            else {
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = .camera
                imgPicker.mediaTypes = [kUTTypeMovie,kUTTypeImage] as [String]
                
                UIViewController.top?.present(imgPicker, animated: true, completion: {() -> Void in
                })
            }
        }
        
        @objc open func onCaptureImageThroughGallery()
        {
            self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                imgPicker.sourceType = .photoLibrary
                imgPicker.mediaTypes = [kUTTypeMovie,kUTTypeImage] as [String]
                UIViewController.top?.present(imgPicker, animated: true, completion: {() -> Void in
                })
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            //Video Picking Process
            if let videoUrl = (info[UIImagePickerController.InfoKey.mediaURL]) as? NSURL{
                
                if let thumbnailImage = thumbnailImageForFileUrl(fileUrl: videoUrl as URL){
    //                let videoData = NSData(contentsOf: videoUrl as URL)
                    picker.dismiss(animated: true, completion: {() -> Void in
                        print("Now")
                        
                    })
                }
            }
            else{
              handleImageSelectedForInfo(info: info,picker: picker)
            }
            
        }
        
        
        private func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage?{
            let asset = AVAsset(url: fileUrl)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            do{
                let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1,timescale: 60), actualTime: nil)
                return UIImage(cgImage: thumbnailCGImage)
            }
            catch let err{
                print(err)
            }
            return nil
            
        }
       
        
       
        //MARK:- Selected Image
        private func handleImageSelectedForInfo(info: [UIImagePickerController.InfoKey: Any],picker: UIImagePickerController){
            //Image Picking Process
            var selectedImage: UIImage?
            if let editedImage = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage){
                selectedImage = editedImage
            }
            else if let originalImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage){
                selectedImage = originalImage
            }
            
            if let finalImage = selectedImage{
                picker.dismiss(animated: true, completion: {() -> Void in
                    self.addAttachmentBtn.setTitle("", for: UIControl.State.normal)
                    self.addAttachmentBtn.sainiShowLoader(loaderColor: #colorLiteral(red: 0.8784313725, green: 0.1333333333, blue: 0.3215686275, alpha: 1))
                    User.uploadMessage(roomRef: self.roomRef, message: compressImage(image: finalImage), messageType: MESSAGE_TYPE.image) { (success) in
                        self.addAttachmentBtn.sainiRemoveLoader()
                        self.addAttachmentBtn.setTitle("𒔉", for: UIControl.State.normal)
                        print("Chat Image sent successfully!")
                    }
                   
                })
            }
        }

    deinit{
        print("Chat Controller Deinit successfully!")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatController: UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatControllerVM.messageCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        headerLbl.text = getReadableDate(timeStamp: ChatControllerVM.message(index: indexPath.row).timestamp)
        switch ChatControllerVM.message(index: indexPath.row).messageType{
            //Text Message
            case "text":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextChatCell", for: indexPath) as? TextChatCell else{
                    return UITableViewCell()
                }
                cell.MSG = ChatControllerVM.message(index: indexPath.row)
                return cell
        
            //Image Message
            case "image":
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageChatCell", for: indexPath) as? ImageChatCell else{
                    return UITableViewCell()
                }
                cell.MSG = ChatControllerVM.message(index: indexPath.row)
                return cell
        
            //Video Message
            case "video":
            break
        default:
            break
            
        }
        return UITableViewCell()
    }
    
    //MARK:- Show/Hide Header View
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.headerView.alpha = 1
        }
       
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.headerView.alpha = 0
        }
       
    }
   
}
