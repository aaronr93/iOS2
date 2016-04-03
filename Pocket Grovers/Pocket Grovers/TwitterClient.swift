//
//  Twitter.swift
//  Pocket Grovers
//
//  Created by Zach Nafziger on 3/31/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterClient{
    static let sharedInstance = TwitterClient()
    let client = TWTRAPIClient(userID: Twitter.sharedInstance().sessionStore.session()!.userID)
    
    
    func findUserTweets(screenName: String)->[Tweet]{
        var returnTweets = [Tweet]()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["screen_name": screenName, "count":"100"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            do{
                if (connectionError == nil) {
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    for tweet  in (json as! [AnyObject]){
                        let text = tweet["text"]!!
                        returnTweets.append(Tweet(text:text as! String))
                    }
                }
                else {
                    print("Error: \(connectionError)")
                }
            } catch{
                print("Something bad happened")
            }
        }
        return returnTweets
    }
    
    func findUser(query:String) -> String{
        var retUser = "officialjaden"//default user in case nothing is found
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/search.json"
        let params = ["q": query, "count":"1"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            do{
                if (connectionError == nil) {
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    for user  in (json as! [AnyObject]){
                        let screen_name = user["screen_name"]!!
                        print(screen_name)
                        retUser = screen_name as! String
                    }
                }
                else {
                    print("Error: \(connectionError)")
                }
            } catch{
                print("Something bad happened")
            }
        }
        return retUser
    }
}
        

