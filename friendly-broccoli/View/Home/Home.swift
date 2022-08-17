//
//  Home.swift
//  EASY
//
//  Created by Rohit Saini on 15/01/19.
//  Copyright © 2019 Rohit Saini. All rights reserved.
//

import UIKit

class Home: UIViewController,UICollectionViewDelegateFlowLayout {
    
    // OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var bottomConstraintOfCollectionView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
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
        super.viewWillAppear(animated)
        if self.tabBarController != nil
        {
            let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
            self.edgesForExtendedLayout = UIRectEdge.bottom
            tabBar.setTabBarHidden(tabBarHidden: false)
        }
        
        let screenHeight = SCREEN.HEIGHT
        let height: DEVICE_TYPE = DEVICE_TYPE(rawValue: Int(screenHeight)) ?? .iPhone_6
        switch height {
        case .iPhone_6:
            bottomConstraintOfCollectionView.constant = 56
        case .iPhone_6_Plus:
            bottomConstraintOfCollectionView.constant = 56
        case .iPhone_SE_1st_gen:
            bottomConstraintOfCollectionView.constant = 56
        case .iPhone_8_Plus:
            bottomConstraintOfCollectionView.constant = 56
        case .iPhone_X:
            bottomConstraintOfCollectionView.constant = 100
        case .iPhone_XS_Max:
            bottomConstraintOfCollectionView.constant = 90
        case .iPhone_12:
            bottomConstraintOfCollectionView.constant = 90
        case .iPhone_12_Pro_Max:
            bottomConstraintOfCollectionView.constant = 96
        }
    }
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

