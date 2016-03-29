//
//  UserTweets.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//d

import Foundation

class UserTweets: NSObject {
    var tweets = [Tweet]()
    var username: String!
    func load() {
        //GET https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(username)
        
    }
    init(username:String){
        self.username = username
    }
}