//
//  Settings.swift
//  EASY
//
//  Created by Rohit Saini on 15/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class Settings: UIViewController {

    //OUTLETS
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundProfileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        backgroundProfileImage.sainiSaabBlur(blurValue: 5)
        profileImage.sainiCornerRadius(radius: profileImage.frame.height / 2)
    }
    
    //MARK:- configUI
    private func configUI(){
        profileImage.sainiCornerRadius(radius: profileImage.frame.height / 2)
        
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.profileCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.profileCell.rawValue)
        
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

//MARK: - TableView DataSource and Delegate Methods
extension Settings: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STATIC_DATA_TYPE.allCases.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.profileCell.rawValue, for: indexPath) as? profileCell else { return UITableViewCell() }
//        cell.listImage.image = UIImage(named: STATIC_ARRAYS.listImagesArray[indexPath.row])
        cell.listTextLbl.text = STATIC_DATA_TYPE.allCases[indexPath.row].getValue()
        if indexPath.row == 4 {
            cell.nextArrowImage.isHidden = true
        }else {
            cell.nextArrowImage.isHidden = false
        }
        return cell
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: PROFILE_STORYBOARD.StaticVC.rawValue) as! StaticVC
//            vc.staticDataType = .aboutUs
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 1:
//            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: PROFILE_STORYBOARD.StaticVC.rawValue) as! StaticVC
//            vc.staticDataType = .terms
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 2:
//            // help
//            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: PROFILE_STORYBOARD.HelpVC.rawValue) as! HelpVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 3:
//            // invite user
//            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: PROFILE_STORYBOARD.InviteUserVC.rawValue) as! InviteUserVC
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 4:
//            // logout
//            alertPopUp.displayAlert(vc: self, alertTitle: "Logout", message: "Are you sure?", okBtnTitle: "Yes", cancelBtnTitle: "Cancel")
//            break
//        default:
//            break
//        }
    }
}
