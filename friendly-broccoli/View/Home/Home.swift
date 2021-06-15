//
//  Home.swift
//  EASY
//
//  Created by Rohit Saini on 15/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class Home: UIViewController,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        log.success("\(Log.stats())This is a success log Test and i want this log on my server")/
        log.error(" \(Log.stats())This is an error log test i want this log on my server")/
        log.url(" \(Log.stats())This is a url log Test: https://google.com i want this log on my server")/
        log.warning(" \(Log.stats())This a warning test! i want this log on my server")/
        log.ln(" \(Log.stats())Line Test i want this log on my server")/
        
        configUI()
        
        // Do any additional setup after loading the view.
    }
    
    private func configUI(){
        collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        let flowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
          if self.tabBarController != nil
          {
              let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
              self.edgesForExtendedLayout = UIRectEdge.bottom
              tabBar.setTabBarHidden(tabBarHidden: false)
          }
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


//MARK:- CollectionView Delegate and Datasource methods
extension Home: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GROUPS_CATEGORIES.GROUP_PHOTOS_PLUS_NAME.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell else{
            return UICollectionViewCell()
        }
        cell.homePic.image = UIImage(named: GROUPS_CATEGORIES.GROUP_PHOTOS_PLUS_NAME[indexPath.row])
        cell.postTitleLbl.text = GROUPS_CATEGORIES.GROUP_PHOTOS_PLUS_NAME[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: PostListingVC = STORYBOARD.HOME.instantiateViewController(withIdentifier: "PostListingVC") as! PostListingVC
        vc.postType = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: - collectionFlowViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellH : CGFloat = collectionView.frame.size.height - 10
        let cellW : CGFloat = collectionView.frame.size.width - 10
        
        return CGSize(width: cellW / 2, height: cellH / 2)
    }
    
}

