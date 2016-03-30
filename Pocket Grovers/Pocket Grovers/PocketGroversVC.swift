//
//  PocketGroversVC.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import UIKit
import Social
import Accounts




class PocketGroversVC: UIViewController {

    @IBOutlet weak var console: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var awayImage: UIImageView!

    var player1 = StudentDirectoryItem(id: "452071")
    var player2 = StudentDirectoryItem(id: "453298")
    let queue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        console.font = UIFont(name: "PokemonGB", size: 18)
        homeName.font = UIFont(name: "PokemonGB", size: 14)
        awayName.font = UIFont(name: "PokemonGB", size: 14)
        
        //download images in the background
        getImages()
        
        //set the names
        homeName.text = player1.name!.componentsSeparatedByString(" ")[0]
        awayName.text = player2.name!.componentsSeparatedByString(" ")[0]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load images in the background
    func getImages(){
        let op = imageDownloader(url: player1.image! as String)
        op.completionBlock = {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if(!op.cancelled){
                    self.homeImage.image = op.image
                }
            })
        }
        queue.addOperation(op)
        
        let op2 = imageDownloader(url: player2.image! as String)
        op2.completionBlock = {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if(!op2.cancelled){
                    self.awayImage.image = op2.image
                }
            })
        }
        queue.addOperation(op2)
    }

}
