//
//  PostDetailsVC.swift
//  EASY
//
//  Created by Rohit Saini on 26/11/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PostDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var postDetailsData: FirebasePost!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()

        // Do any additional setup after loading the view.
    }
    
    private func configUI(){
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib.init(nibName: "PostDetailsMediaCell", bundle: nil), forCellReuseIdentifier: "PostDetailsMediaCell")
        tableView.register(UINib.init(nibName: "PostDetailsContentCell", bundle: nil), forCellReuseIdentifier: "PostDetailsContentCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }

    
    
    deinit{
        print("Post Details Deinit successfully!")
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

extension PostDetailsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailsMediaCell", for: indexPath) as? PostDetailsMediaCell else{return UITableViewCell()}
            cell.postedByUserPic.downloadCachedImage(placeholder: "user_avatar", urlString: postDetailsData.creatorProfilePic)
            cell.postByUsername.text = postDetailsData.username
            if postDetailsData.mediaType == "IMAGE"{
                cell.playBtn.isHidden = true
                cell.postPic.downloadCachedImage(placeholder: "", urlString: postDetailsData.postUrl)
            }
            else{
               cell.playBtn.isHidden = false
                cell.postPic.downloadCachedImage(placeholder: "", urlString: postDetailsData.videoThumbnail)
            }
            cell.playBtn.addTarget(self, action: #selector(playVideo), for: UIControl.Event.touchUpInside)
            cell.backBtn.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailsContentCell", for: indexPath) as? PostDetailsContentCell else{return UITableViewCell()}
            cell.titleLbl.text = "Post Content"
            cell.subtitleLbl.text = postDetailsData.postText
            return cell
        }
    }
    
    //MARK:- playVideo
    @objc func playVideo(){
        
        let videoURL = URL(string: postDetailsData.postUrl)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    }
    //MARK:- back
      @objc func back(){
        self.navigationController?.popViewController(animated: true)
      }
    
    
}
