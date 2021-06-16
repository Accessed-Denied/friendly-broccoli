//
//  AppEnums.swift
//  friendly-broccoli
//
//  Created by MACBOOK on 17/06/21.
//

import Foundation

//MARK: - TABLE_VIEW_CELL
enum TABLE_VIEW_CELL: String {
    case profileCell
}

//MARK: - STATIC_DATA_TYPE
enum STATIC_DATA_TYPE:String, CaseIterable{
    case aboutUs = "About Us"
    case terms = "Terms & Conditions"
    case help = "Help"
    case inviteUser = "Invite User"
    case logout = "Logout"
    func getValue() -> String {
        return self.rawValue
    }
}
