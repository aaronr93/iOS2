//
//  PocketGroversVC.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import UIKit

class PocketGroversVC: UIViewController {

    @IBOutlet weak var console: UILabel!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var awayImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        console.font = UIFont(name: "PokemonGB", size: 18)
        homeName.font = UIFont(name: "PokemonGB", size: 18)
        awayName.font = UIFont(name: "PokemonGB", size: 18)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
