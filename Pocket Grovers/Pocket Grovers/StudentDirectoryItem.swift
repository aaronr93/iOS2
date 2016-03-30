//
//  StudentDirectoryItem.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation

class StudentDirectoryItem: NSObject {
    var name: NSString?
    var image: NSString?
    var city: NSString?
    var state: NSString?
    var id: NSString?
    
    init(id: NSString) {
        self.id = id
        self.image = "http://glance.gcc.edu/student_fullres/\(id).jpg"
        
        let glanceURL = NSURL(string: "http://glance.gcc.edu/student_pages/\(id).php")
        var html = NSString()
        do {
            html = try NSString(contentsOfURL: glanceURL!, encoding: NSUTF8StringEncoding)
        } catch {
            print(error)
        }
        
        //split the html into lines - inspired by http://stackoverflow.com/questions/32021712/how-to-split-a-string-by-new-lines-in-swift
        let newlineChars = NSCharacterSet.newlineCharacterSet()
        let index = (html as String).startIndex.advancedBy(16)
        let lines = (html as String).utf16.split { newlineChars.characterIsMember($0) }.flatMap(String.init)
        self.name = lines[44].substringFromIndex(index).componentsSeparatedByString("<")[0]
        
    }
    
    init(name: NSString, city: NSString, state: NSString, id: NSString){
        self.name = name
        self.city = city
        self.state = state
        self.id = id
    }
    
    func createDictionary() -> NSArray {
        let dict = NSMutableDictionary()
        let data = NSMutableArray()
        
        dict.setValue(name, forKey: "name")
        dict.setValue(image, forKey: "image")
        dict.setValue(city, forKey: "city")
        dict.setValue(state, forKey: "state")
        dict.setValue(id, forKey: "id")
        
        data.addObject(dict)
        return data
    }

    func toJSON() -> NSData {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(self.createDictionary(), options: .PrettyPrinted)
            print("\(data)")
            return data
        } catch {
            print("error")
        }
        return NSData()
    }
    
}
