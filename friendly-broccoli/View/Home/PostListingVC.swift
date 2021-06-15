//
//  PostListingVC.swift
//  EASY
//
//  Created by Rohit Saini on 02/10/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PostListingVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var postType: Int = Int()
    
    var postListVM: PostListViewModel = PostListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        postListVM.fetchRealTimePosts(postType: postType) {
            self.tableView.reloadData()
        }
        
        configUI()
       

        // Do any additional setup after loading the view.
    }
    
    
      //MARK:- configUI
    private func configUI(){
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        
        postTitle.text = GROUPS_CATEGORIES.GROUP_PHOTOS_PLUS_NAME[postType]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            self.edgesForExtendedLayout = UIRectEdge.bottom
            tabBar.setTabBarHidden(tabBarHidden: true)
        }
    }
    
   
      //MARK:- Tableview delegate and datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postListVM.postCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        if postListVM.PostDataSource[indexPath.row].mediaType == "IMAGE"{
        cell.playBtn.isHidden = true
        cell.postImageView.contentMode = .scaleAspectFill
        cell.usernameLbl.text = postListVM.PostDataSource[indexPath.row].username
        cell.postContentLbl.text = ""
        cell.dateLbl.text = ""
        cell.postImageView.downloadCachedImage(placeholder: "ic_logo", urlString: postListVM.PostDataSource[indexPath.row].postUrl)
        let UserImage = UIImageView()
            UserImage.downloadCachedImage(placeholder: "", urlString: postListVM.PostDataSource[indexPath.row].creatorProfilePic)
        cell.userBtn.setImage(UserImage.image, for: UIControl.State.normal)
        }
        else{
            cell.playBtn.isHidden = false
            cell.postImageView.contentMode = .scaleAspectFill
            cell.usernameLbl.text = postListVM.PostDataSource[indexPath.row].username
            cell.postContentLbl.text = ""
            cell.dateLbl.text = ""
            cell.postImageView.downloadCachedImage(placeholder: "", urlString: postListVM.PostDataSource[indexPath.row].videoThumbnail)
            let UserImage = UIImageView()
                UserImage.downloadCachedImage(placeholder: "user_avatar", urlString: postListVM.PostDataSource[indexPath.row].creatorProfilePic)
            cell.userBtn.setImage(UserImage.image, for: UIControl.State.normal)
        }
        cell.createdOnLbl.text = getReadableDate(timeStamp: postListVM.PostDataSource[indexPath.row].timestamp)
        cell.userBtn.tag = indexPath.row
        cell.userBtn.addTarget(self, action: #selector(showProfile(sender:)), for: .touchUpInside)
        cell.playBtn.addTarget(self, action: #selector(playVideo(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: PostDetailsVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "PostDetailsVC") as! PostDetailsVC
        vc.postDetailsData = postListVM.PostDataSource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickBackBtn(_ sender: UIButton) {
        NAVIGATION.BackToPreviousController()
    }
    
      //MARK:- showProfile
    @objc func showProfile(sender: UIButton){
        let vc: ProfileVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.userId = postListVM.PostDataSource[sender.tag].userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- showProfile
    @objc func playVideo(sender: UIButton){
        let videoURL = URL(string: postListVM.PostDataSource[sender.tag].postUrl)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    
   
    
    
    
      //MARK:- deinit
    deinit{
       print("PostListing VC Deinit from memory")
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
