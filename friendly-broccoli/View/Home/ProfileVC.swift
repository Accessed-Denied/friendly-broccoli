//
//  ProfileVC.swift
//  EASY
//
//  Created by Rohit Saini on 16/10/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

   
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var topBackView: UIView!
    var userId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- configUI
    private func configUI(){
        profilePic.layer.cornerRadius =  profilePic.frame.height / 2
        topBackView.layer.cornerRadius = 30
        topBackView.layer.masksToBounds = true
        topBackView.sainiGradientColor(colorArr: COLOR.appGredienColor, vertical: false)
        messageBtn.layer.cornerRadius =   messageBtn.frame.height / 2
        messageBtn.layer.masksToBounds = true
        messageBtn.sainiGradientColor(colorArr: COLOR.appGredienColor, vertical: false)
        
        // if user is logged in user
        if userId == AppModel.shared.loggedInUser.id{
            messageBtn.isHidden = true
            setLoggedinUserData()
            return
        }
        //Downloading user info
        getUserInfo()
        
    }
    
    @IBAction func clickMessageBtn(_ sender: UIButton) {
        sender.sainiPulsate()
        User.sendMessage(receiptUserId: userId)
    }
    
    @IBAction func clickbackBtn(_ sender: UIButton) {
        sender.sainiPulsate()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- getUserInfo
    private func getUserInfo(){
        User.downloadUserInfo(userId: userId) { [unowned self](user) in
            self.profilePic.downloadCachedImage(placeholder: "", urlString: user.profilePicLink)
            self.usernameLbl.text = user.name
            self.emailLbl.text = user.email
        }
    }
    
    //MARK:- set Logged in user Data
    private func setLoggedinUserData(){
        profilePic.downloadCachedImage(placeholder: "", urlString: AppModel.shared.loggedInUser.profilePicLink)
        usernameLbl.text = AppModel.shared.loggedInUser.name
        emailLbl.text = AppModel.shared.loggedInUser.email
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
