//
//  StudentDirectoryItem.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation

class StudentDirectoryItem: NSObject {
    var name: String?
    var image: String?
    var city: String?
    var state: String?
    var id: String?
    
    init(id: String){
        self.id = id
        self.image = "http://glance.gcc.edu/student_fullres/\(id).jpg"
    }
}