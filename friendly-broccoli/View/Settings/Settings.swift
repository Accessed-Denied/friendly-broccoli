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
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- configUI
    private func configUI(){
        
        collectionView.register(UINib(nibName: "ChatFriendCell", bundle: nil), forCellWithReuseIdentifier: "ChatFriendCell")
        let flowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: false)
    }
    
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
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//  //MARK:- COllectionView Delegate and Datasource Methods
//extension Settings: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return SETTING.SETTING_DATA.count
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatFriendCell", for: indexPath) as? LatestMessageCell else{
//            return UICollectionViewCell()
//        }
//        cell.friendNameLbl.text = SETTING.SETTING_DATA[indexPath.row]
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 4{
//           logout()
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellH : CGFloat = collectionView.frame.size.height - 10
//        let cellW : CGFloat = collectionView.frame.size.width - 10
//        
//        return CGSize(width: cellW / 2, height: cellH / 3)
//    }
//}
