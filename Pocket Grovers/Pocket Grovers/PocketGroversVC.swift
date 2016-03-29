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
    
    class GroverObserver:NSObject{
        var target = PocketGrover()
        var image:UIImageView = UIImageView()
        
        func watch(target:PocketGrover, image: UIImageView){
            self.target = target
            self.image = image
            target.addObserver(self, forKeyPath: "health", options: .New, context: nil)
        }
        
        
        
        deinit{
            target.removeObserver(self, forKeyPath: "health")
        }
        
    }

    @IBOutlet weak var console: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var awayImage: UIImageView!

    var player1Student = StudentDirectoryItem(id: "452071")
    var player2Student = StudentDirectoryItem(id: "453298")
    let queue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        console.font = UIFont(name: "PokemonGB", size: 18)
        homeName.font = UIFont(name: "PokemonGB", size: 12)
        awayName.font = UIFont(name: "PokemonGB", size: 12)
        
        //download images in the background
        getImages()
        
        //set the names and generate the pocket grovers
        let grover1 = PocketGrover(glanceInfo: player1Student)
        let grover2 = PocketGrover(glanceInfo: player2Student)
        homeName.text = grover1.name!
        awayName.text = grover2.name!
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load images in the background
    func getImages(){
        let op = imageDownloader(url: player1Student.image!)
        op.completionBlock = {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if(!op.cancelled){
                    self.homeImage.image = op.image
                }
            })
        }
        queue.addOperation(op)
        
        let op2 = imageDownloader(url: player2Student.image!)
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
