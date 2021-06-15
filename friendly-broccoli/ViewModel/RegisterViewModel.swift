//
//  RegisterViewModel.swift
//  EASY
//
//  Created by Rohit Saini on 21/01/20.
//  Copyright © 2020 Rohit Saini. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewModel{
    func registerUser(withName:String,email: String,password: String,phoneNumber: String,profilePic: UIImage,success: @escaping (String?) -> Void){
        User.registerUser(withName: withName, email: email, password: password, phoneNumber: phoneNumber, profilePic: profilePic, loginHandler: {(Loginhandler) in
            success(Loginhandler)
        })
    }
}
