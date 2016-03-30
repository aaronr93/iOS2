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
                dest.player1Student = StudentDirectoryItem(id: p1)
            }
        }
        if let p2 = player2TextField.text{
            if(p2 != "") {
                dest.player2Student = StudentDirectoryItem(id: p2)
            }
        }
        
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        player1TextField.text = "452071"
        player2TextField.text = "453298"
        // Do any additional setup after loading the view.
        
        let directory = DirectoryInformation()
        directory.loadFromFile()
        
        let item = StudentDirectoryItem(id: "446590")
        item.name = "Sam Kibler"
        item.state = "VA"
        item.city = "Roanoke"
        item.image = "kibs.jpg"
        
        let item2 = StudentDirectoryItem(id: "453298")
        item2.name = "Aaron Rosenberger"
        item2.state = "VA"
        item2.city = "Roanoke"
        item2.image = "aaron.jpg"
        
        // Example of save function
        directory.save(item)
        
        // Example of saveAll function
        directory.saveAll([item, item2])
        
        print(directory[0].name!)
        print(directory[1].name!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
