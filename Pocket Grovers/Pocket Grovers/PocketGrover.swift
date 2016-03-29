//
//  PocketGrover.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation

enum State {
    case Burned
    case Frozen
    case Paralyzed
    case Poisoned
    case Sleeping
    case Confused
}

let adjectives = ["Li'l", "Big ass", "Hobo", "Blind", "Hipster", "Nerdy", "Bad Shit", "Poison", "Cyborg", "Fat ass", "Really Old", "Dumb", "Weird", "Gooey", "Fluffy", "Distinguished", "Freshman", "High Schooler", "Extreme", "Dumpy"]

class PocketGrover:NSObject {
    var name: String?
    var actions = [String]()
    var state: State?
    var glanceInfo: StudentDirectoryItem?
    var tweets : UserTweets?
    var health:Int = 10
    init(glanceInfo:StudentDirectoryItem){
        let randAdjNum = Int(arc4random_uniform(UInt32(adjectives.count)))
        name = "\(adjectives[randAdjNum]) \(glanceInfo.name!.componentsSeparatedByString(" ")[0])"
        self.glanceInfo = glanceInfo
    }
    
    init(glanceInfo:StudentDirectoryItem, tweets:UserTweets){
        let randAdjNum = Int(arc4random_uniform(UInt32(adjectives.count)))
        name = "\(adjectives[randAdjNum]) \(glanceInfo.name!.componentsSeparatedByString(" ")[0])"
        self.glanceInfo = glanceInfo
        self.tweets = tweets
    }
    
    override init(){
        let randAdjNum = Int(arc4random_uniform(UInt32(adjectives.count)))
        name = "\(adjectives[randAdjNum]) Grover"
    }
    
}