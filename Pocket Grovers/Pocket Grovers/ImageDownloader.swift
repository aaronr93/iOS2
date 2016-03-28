//
//  ImageDownloader.swift
//  Pocket Grovers
//
//  Created by Zach Nafziger on 3/28/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation
import UIKit

class imageDownloader:NSOperation{
    var url:String
    var image:UIImage = UIImage()
    
    override func main() {
        let urlForDownload = NSURL(string: url)
        let data = NSData(contentsOfURL: urlForDownload!)
        self.image = UIImage(data: data!)!
    }
    
    init(url:String){
        self.url = url
    }
    
}