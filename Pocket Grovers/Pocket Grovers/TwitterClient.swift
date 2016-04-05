//
//  Twitter.swift
//  Pocket Grovers
//
//  Created by Zach Nafziger on 3/31/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation
import TwitterKit

//Note: We use Fabric to manage our twitter requests, and the requests are made in a background thread by default.

class TwitterClient{
    static let sharedInstance = TwitterClient()
    let client = TWTRAPIClient(userID: Twitter.sharedInstance().sessionStore.session()!.userID)
    let stopWords = ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the", "i"]
    
    func findUserTweets(screenName: String, completionHandler:(tweets:[Tweet])->()){
        print("fetching tweets for \(screenName)")
        var tweets = [Tweet]()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["screen_name": screenName, "count":"100"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            do{
                if (connectionError == nil) {
                    
                    //get the raw text
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    for tweet  in (json as! [AnyObject]){
                        let text = tweet["text"]!!
                        tweets.append(Tweet(text:text as! String))
                    }
                    
                    if(tweets.count < 4){
                        self.getTrending({t in
                            completionHandler(tweets: t)
                        })
                    } else {
                        //assign the tweets keywords using tf-idf
                        var documentFrequency = Dictionary<String, Int>()
                        //get the number of documents with each term
                        for tweet in tweets{
                            //remove punctuation
                            let words = tweet.rawText!.lowercaseString.componentsSeparatedByCharactersInSet(.punctuationCharacterSet()).joinWithSeparator("").componentsSeparatedByString(" ").filter{!$0.isEmpty}
                            //get the document frequency
                            for word in words{
                                if let freq = documentFrequency[word]{
                                    documentFrequency[word] = freq + 1
                                } else{
                                    documentFrequency[word] = 1
                                }
                            }
                        }
                        
                        for tweet in tweets{
                            var termScores = [(String, Double)]()
                            
                            let words = tweet.rawText!.lowercaseString.componentsSeparatedByCharactersInSet(.punctuationCharacterSet()).joinWithSeparator("").componentsSeparatedByString(" ").filter{!$0.isEmpty}
                            for word in words{
                                if(!self.stopWords.contains(word.lowercaseString)){
                                    let tf:Double = Double(tweet.rawText!.lowercaseString.componentsSeparatedByString(word).count-1)/Double(words.count)
                                    let idf:Double = log(Double(tweets.count)/Double(documentFrequency[word]!))
                                    termScores.append((word, tf*idf))
                                }
                            }
                            let sortedTerms = termScores.sort{$0.1 > $1.1}
                            //for now, get one keyword
                            tweet.keywords.append(sortedTerms[0].0)
                            
                            //print("\traw text: \(tweet.rawText!.lowercaseString)")
                            //print("\tkey words: \(tweet.keywords)")
                            
                        }
                        completionHandler(tweets: tweets)
                    }
                    
                }
                else {
                    print("Error: \(connectionError)")
                    self.getTrending({t in
                        completionHandler(tweets: t)
                    })
                }
            } catch{
                print("Something bad happened")
                self.getTrending({t in
                    completionHandler(tweets: t)
                })
            }
        }
        
        
        
    }
    
    func findUser(query:String, completionHandler:(name:String)->()){
        var retUser = "officialjaden"//default user in case nothing is found
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/search.json"
        let params = ["q": query, "count":"10"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            do{
                if (connectionError == nil) {
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    let users = json as! [AnyObject]
                    let randNum = Int(arc4random_uniform(UInt32(users.count)))
                    let screen_name = users[randNum]["screen_name"]!!
                    print(screen_name)
                    retUser = screen_name as! String
                    completionHandler(name: retUser)
                }
                else {
                    print("Error: \(connectionError)")
                }
            } catch{
                print("Something bad happened")
            }
        }
    }
    
    func tweetsFromQuery(query:String, completionHandler:(uT:UserTweets)->()){
        var user = "officialjaden"//default user in case nothing is found
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/search.json"
        let params = ["q": query, "count":"10"]
        var clientError : NSError?
        let userTweets = UserTweets()
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            do{
                if (connectionError == nil) {
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    let users = json as! [AnyObject]
                    if(users.count > 0){
                        let randNum = Int(arc4random_uniform(UInt32(users.count)))
                        let screen_name = users[randNum]["screen_name"]!!
                        print(screen_name)
                        user = screen_name as! String
                    }
                    userTweets.username = user
                    self.findUserTweets(user, completionHandler: {t in
                        userTweets.tweets = t
                        completionHandler(uT: userTweets)
                    })
                }
                else {
                    print("Error: \(connectionError)")
                    userTweets.username = user
                    self.findUserTweets(user, completionHandler: {t in
                        userTweets.tweets = t
                        completionHandler(uT: userTweets)
                    })
                }
            } catch{
                print("Something bad happened")
                userTweets.username = user
                self.findUserTweets(user,completionHandler: {t in
                    userTweets.tweets = t
                    completionHandler(uT: userTweets)
                })
            }
        }
    }
    
    func getTrending(completionHandler:(tweets:[Tweet])->()){
        print("couldn't find tweets.. getting US trends instead")
        var tweets = [Tweet]()
        //finds trending topics in the us
        let statusesShowEndpoint = "https://api.twitter.com/1.1/trends/place.json"
        let params = ["id":"23424977"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            do{
                if (connectionError == nil) {
                    let json : AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    //print(json)
                    let results = json as! [AnyObject]
                    let trends = results[0]["trends"] as! [AnyObject]
                    for trend in trends{
                        let content = trend["name"]!!
                        print(content)
                        let tweet = Tweet(text: content as! String)
                        tweet.keywords = [tweet.rawText!]
                        tweets.append(tweet)
                    }
                    
                    completionHandler(tweets: tweets)
                }
                else {
                    print("Error: \(connectionError)")
                }
            } catch{
                print("Something bad happened")
            }
        }
    }
}
        

