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

let adjectives = ["Li'l", "Big Ol'", "Hobo", "Blind", "Hipster", "Nerdy", "Bad", "Cyborg", "Tubby", "Really Old", "Dumb", "Weird", "Gooey", "Fluffy", "Freshman", "High Schooler", "Extreme", "Dumpy", "Hairy", "Smelly", "The Dark Lord", "A Wild", "Feral", "Extra Large", "Teat", "Stoner", "Unhealthy", "Half of", "Left Ear of", "Right Ear of", "Not", "Crazy", "Attractive", "Uncle", "Professor", "A Boy Called", "A Girl Called", "Super", "Hashtag", "Zombie", "Father", "Mother", "Racist", "Student Formerly Known As", "Bite-Sized", "Mythological", "Mr.", "Mrs.", "Wizard", "Private", "Schwifty", "Sexist", "Curious"]

class PocketGrover:NSObject {
    var name: String?
    var actions = [String]()
    var state: State?
    var glanceInfo: StudentDirectoryItem?
    var tweets : UserTweets?
    dynamic var health = 10
    func loseHealth(amount:Int){
        health -= amount
    }
    init(glanceInfo:StudentDirectoryItem){
        print("generating pocket grover")
        let randAdjNum = Int(arc4random_uniform(UInt32(adjectives.count)))
        name = "\(adjectives[randAdjNum]) \(glanceInfo.name!.componentsSeparatedByString(" ")[0])"
        self.glanceInfo = glanceInfo
        //search twitter using first and last name
        tweets = UserTweets()
        TwitterClient.sharedInstance.tweetsFromQuery("\(glanceInfo.name!.componentsSeparatedByString(" ")[0]) \(glanceInfo.name!.componentsSeparatedByString(" ")[2])", userTweets: tweets!)
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