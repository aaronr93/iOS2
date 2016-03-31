//
//  WelcomeVC.swift
//  Pocket Grovers
//
//  Created by Zach Nafziger on 3/28/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import UIKit
import TwitterKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var player1TextField : UITextField!
    @IBOutlet weak var player2TextField : UITextField!
    
    let directory = DirectoryInformation()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! PocketGroversVC
        
        if let p1 = player1TextField.text {
            if (p1 != "") {
                dest.player1Student = directory[p1]
            }
        }
        if let p2 = player2TextField.text {
            if (p2 != "") {
                dest.player2Student = directory[p2]
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        player1TextField.text = "452071"
        player2TextField.text = "453298"
        // Do any additional setup after loading the view.
        
        directory.loadFromFile()
        
        for person in directory.directoryItems {
            print(person.id!)
        }
        
        TwitterClient.sharedInstance.findUserTweets("twitter")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
