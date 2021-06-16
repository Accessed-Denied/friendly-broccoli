//
//  Settings.swift
//  EASY
//
//  Created by Rohit Saini on 15/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class Settings: UIViewController {

    @IBOutlet weak var navBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- configUI
    private func configUI(){
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: false)
    }
    
    //MARK: - logout
    private func logout(){
        let attributedString = NSAttributedString(string: "Log Out", attributes: [
            
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),
            
        ])
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alertController.setValue(attributedString, forKey: "attributedTitle")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            
        }
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            User.updateUserOnlineStatus(userId: AppModel.shared.loggedInUser.id, isOnline: false)
            
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = navigationVC
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.view.tintColor = #colorLiteral(red: 0.8784313725, green: 0.1333333333, blue: 0.3215686275, alpha: 1)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
