//
//  PostListViewModel.swift
//  EASY
//
//  Created by Rohit Saini on 21/01/20.
//  Copyright © 2020 Rohit Saini. All rights reserved.
//

import Foundation
import UIKit

class PostListViewModel{
    var PostDataSource: [FirebasePost] = [FirebasePost]()
    
    //fetching Post updates
    func fetchRealTimePosts(postType: Int,_ completion: @escaping() -> Void){
        User.realtimeUpdatedPosts(postType: "\(postType)") { [weak self](post) in
            self?.PostDataSource.append(post)
            self?.PostDataSource = (self?.PostDataSource.sorted(by: { $0.timestamp > $1.timestamp }))!
            completion()
        }
    }
    
    func postCount() -> Int{
        return PostDataSource.count
    }
    
    func post(index: Int) -> FirebasePost{
        let post = PostDataSource[index]
        return post
    }
}
