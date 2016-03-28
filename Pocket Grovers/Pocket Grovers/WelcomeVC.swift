//
//  WelcomeVC.swift
//  Pocket Grovers
//
//  Created by Zach Nafziger on 3/28/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var player1TextField : UITextField!
    @IBOutlet weak var player2TextField : UITextField!
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! PocketGroversVC
        
        if let p1 = player1TextField.text{
            if(p1 != "" ){
                dest.player1 = StudentDirectoryItem(id: p1)
            }
        }
        if let p2 = player2TextField.text{
            if(p2 != "") {
                dest.player2 = StudentDirectoryItem(id: p2)
            }
        }
        
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
