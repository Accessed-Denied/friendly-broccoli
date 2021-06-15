//
//  LoginViewModel.swift
//  EASY
//
//  Created by Rohit Saini on 21/01/20.
//  Copyright © 2020 Rohit Saini. All rights reserved.
//

import Foundation

class LoginViewModel{
    
    //Login User
    func loginUser(email: String,password: String,success: @escaping (String?) -> Void){
        User.loginUser(email: email, password: password, loginHandler: {(Loginhandler) in
            success(Loginhandler)
        })
    }
}
