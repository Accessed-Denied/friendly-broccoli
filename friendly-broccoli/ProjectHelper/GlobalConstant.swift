//
//  GlobalConstant.swift
//  EASY
//
//  Created by Rohit Saini on 13/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import Foundation
import UIKit


//BubbleType
enum ChatBubbleType{
    case incoming
    case outgoing
}

//========================
//MARK:- STORYBOARD
struct STORYBOARD {
    static var MAIN = UIStoryboard(name: "Main", bundle: nil)
    static var HOME = UIStoryboard(name: "Home", bundle: nil)
    static var MYCHAT = UIStoryboard(name: "MyChat", bundle: nil)
    static var GROUPCHAT = UIStoryboard(name: "GroupChat", bundle: nil)
    static var SETTINGS = UIStoryboard(name: "Settings", bundle: nil)
    
}

//MARK:- SETTING
struct SETTING {
    static var SETTING_DATA = ["About","Help","Tell a friend","Share","Logout"]    
}

//========================
//MARK:- GROUPS_CATEGORIES
struct GROUPS_CATEGORIES {
    static var GROUP_PHOTOS_PLUS_NAME = ["Technology","Education","Travel","Gym","Fashion","Sports","Etc"]
}

//========================
//MARK:- NAVIGATION
struct NAVIGATION{
  
    static func BackToPreviousController(){
    UIViewController.top?.navigationController?.popViewController(animated: true)
    }
}

struct COLOR {
    static let appGredienColor = [colorFromHex(hex: "#ED6E27").cgColor,colorFromHex(hex: "#FF5936").cgColor]
    static let NavBarColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
}

struct NOTIFICATIONS {
    static let PlaySound = Notification.Name("PlaySound")
}

struct AppConstants {
    static var shouldPlaySound = true
}


