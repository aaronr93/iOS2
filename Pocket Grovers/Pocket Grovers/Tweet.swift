//
//  Tweet.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation

class Tweet {
    var rawText: String?
    var keywords = [String]()
    init(text:String){
        rawText = text
    }
}