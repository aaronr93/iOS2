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




class PocketGroversVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
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
            if(target.health > 0){
                let blurView = UIView(frame: image.bounds)
                blurView.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 0.5, blue: 0.5, alpha: 0.2)
                image.addSubview(blurView)
            } else{
                infoLabel.text = ("\(target.name!) is dead.")
            }
        }
        
        deinit{
            target.removeObserver(self, forKeyPath: "health")
        }
        
    }
    
    class AttackPopulater:NSObject{
        var target:PocketGrover!
        var updateData:(([String])->())!
        
        func watch(target:PocketGrover, updateData:([String])->()){
            self.target = target
            self.updateData = updateData
            target.addObserver(self, forKeyPath: "hasTweets", options: .New, context: nil)
        }
        
        
        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            print("populating attacks")
            var data = ["Select an Attack","1", "2", "3", "4"]
            for i in 1..<data.count{
                let randNum = Int(arc4random_uniform(UInt32((target.tweets?.tweets.count)!)))
                data[i] = (target.tweets?.tweets[randNum].keywords[0])!
            }
            updateData(data)
            
        }
        
        deinit{
            target.removeObserver(self, forKeyPath: "hasTweets")
        }
        
    }
    
    @IBOutlet weak var console: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var attackPicker : UIPickerView!
    @IBOutlet weak var attackButton: UIButton!
    

    var player1Student:StudentDirectoryItem!
    var player2Student:StudentDirectoryItem!
    var grover1:PocketGrover!
    var grover2:PocketGrover!
    let queue = NSOperationQueue()
    let observer1 = GroverObserver()
    let observer2 = GroverObserver()
    let attackPopulater = AttackPopulater()
    var selectedAttack = 0
    var attackData = ["Select an Attack", "Attack 1", "Attack 2", "Defense 1", "Defense 2"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fonts
        console.font = UIFont(name: "PokemonGB", size: 16)
        homeName.font = UIFont(name: "PokemonGB", size: 20)
        awayName.font = UIFont(name: "PokemonGB", size: 20)
        attackButton.titleLabel?.font = UIFont(name: "Pokemon GB", size: 20)
        
        //download images in the background
        getImages()
        
        //set the names and generate the pocket grovers
        grover1 = PocketGrover(glanceInfo: player1Student)
        grover2 = PocketGrover(glanceInfo: player2Student)
        homeName.text = grover1.name!
        awayName.text = grover2.name!
        
        console.text = "\(grover2.name!) wants to fight!"
        
        //watch the grovers
        observer1.watch(grover1, image: homeImage, infoLabel: console)
        observer2.watch(grover2, image: awayImage, infoLabel: console)
        
        
        //set up the attack picker
        attackPicker.dataSource = self
        attackPicker.delegate = self
        attackPicker.selectRow(0, inComponent: 0, animated: false)
        
        //watch for attack data
        attackPopulater.watch(grover1, updateData:{data in
            self.attackData = data
            self.attackPicker.reloadAllComponents()
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //load images in the background
    func getImages(){
        let op = imageDownloader(url: player1Student.image! as String)
        op.completionBlock = {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if(!op.cancelled){
                    self.homeImage.image = op.image
                }
            })
        }
        queue.addOperation(op)
        
        let op2 = imageDownloader(url: player2Student.image! as String)
        op2.completionBlock = {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                if(!op2.cancelled){
                    self.awayImage.image = op2.image
                    
                }
            })
        }
        queue.addOperation(op2)
    }
    
    
    //picker stuff
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return attackData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return attackData[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = attackData[row]
        pickerLabel.font = UIFont(name: "PokemonGB", size: 14)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAttack = row
    }
    
    @IBAction func attack(){
        if(selectedAttack != 0){
            grover2.loseHealth(1)
            console.text = "\(grover1.name!) used \(attackData[attackPicker.selectedRowInComponent(0)])! Now \(grover2.name!) has \(grover2.health) health."
        } else {
            console.text = "Please select an attack."
        }
    }
    
}
