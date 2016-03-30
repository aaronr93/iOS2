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
        var target:PocketGrover!
        var image:UIImageView = UIImageView()
        var infoLabel:UILabel = UILabel()
        
        func watch(target:PocketGrover, image: UIImageView, infoLabel:UILabel){
            self.target = target
            self.image = image
            self.infoLabel = infoLabel
            target.addObserver(self, forKeyPath: "health", options: .New, context: nil)
        }
        
        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            infoLabel.text = ("\(target.name!) lost health! Health is now \(change![NSKeyValueChangeNewKey]!).")
            let blurView = UIView(frame: image.bounds)
            blurView.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 0.5, blue: 0.5, alpha: 0.2)
            image.addSubview(blurView)
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
    var grover1:PocketGrover!
    var grover2:PocketGrover!
    let queue = NSOperationQueue()
    let observer1 = GroverObserver()
    let observer2 = GroverObserver()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        console.font = UIFont(name: "PokemonGB", size: 10)
        homeName.font = UIFont(name: "PokemonGB", size: 12)
        awayName.font = UIFont(name: "PokemonGB", size: 12)
        
        //download images in the background
        getImages()
        
        //set the names and generate the pocket grovers
        grover1 = PocketGrover(glanceInfo: player1Student)
        grover2 = PocketGrover(glanceInfo: player2Student)
        homeName.text = grover1.name!
        awayName.text = grover2.name!
        
        //watch the grovers
        observer1.watch(grover1, image: homeImage, infoLabel: console)
        observer2.watch(grover2, image: awayImage, infoLabel: console)
        
        
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
    
    @IBAction func testObserver(){
        print(grover1.name!)
        grover1.loseHealth(1)
        print(grover1.health)
    }

}
