//
//  MyChat.swift
//  EASY
//
//  Created by Rohit Saini on 15/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class MyChat: UIViewController {
    
    @IBOutlet weak var navBarView: View!
    @IBOutlet weak var tableView: UITableView!
    private var selectedIndex = 1
    var MyChatListVM:MyChatListViewModel = MyChatListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       configUI()
        // Do any additional setup after loading the view.
    }
    
    private func configUI(){
        
        tableView.register(UINib.init(nibName: "LatestMessageCell", bundle: nil), forCellReuseIdentifier: "LatestMessageCell")
        MyChatListVM.fetchChatUserList {
            self.tableView.reloadData()
        }
        MyChatListVM.updateUserOnlineStatus {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           
           let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
           tabBar.setTabBarHidden(tabBarHidden: false)
       }
    


}


  //MARK:- COllectionView Delegate and Datasource Methods
extension MyChat: UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- Tableview delegate and datasource
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 100
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyChatListVM.userCount()
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "LatestMessageCell", for: indexPath) as? LatestMessageCell else {
             return UITableViewCell()
         }
        cell.conversation = MyChatListVM.user(index: indexPath.row)
        return cell
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: ChatController = STORYBOARD.MYCHAT.instantiateViewController(withIdentifier: "ChatController") as! ChatController
        vc.roomRef = MyChatListVM.user(index: indexPath.row).lastMessage.roomRef
        vc.userId = MyChatListVM.user(index: indexPath.row).user.id
        vc.username = MyChatListVM.user(index: indexPath.row).user.name
        NotificationCenter.default.post(name: NOTIFICATIONS.PlaySound, object: ["data":false])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
  
   
}
