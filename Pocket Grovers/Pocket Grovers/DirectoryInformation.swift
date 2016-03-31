//
//  DirectoryInformation.swift
//  Pocket Grovers
//
//  Created by Aaron Rosenberger on 3/21/16.
//  Copyright © 2016 Nafberger Games. All rights reserved.
//

import Foundation

class DirectoryInformation: NSObject {
    
    var directoryItems = [StudentDirectoryItem]()
    let fileManager = NSFileManager.defaultManager()
    
    override init() {
        super.init()
        directoryItems.removeAll()
    }
    
    subscript(id: NSString) -> StudentDirectoryItem {
        get {
            // Find an item that matches the subscripted ID
            for item in directoryItems {
                if item.id! == id {
                    return item
                }
            }
            
            // If we didn't find it, create and save it
            let newItem = StudentDirectoryItem(id: id)
            self.save(newItem)
            return newItem
        }
    }
    
    func loadFromFile() {
        let dirpath: NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let path = dirpath.stringByAppendingPathComponent("DirectoryInformation.json")
        
        if fileManager.fileExistsAtPath(path) {
            do {
                let contents = NSData(contentsOfFile: path)
                let item = try NSJSONSerialization.JSONObjectWithData(contents!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                loadDirectory(item)
            } catch {
                print("File cannot be read")
            }
        }
    }
    
    private func loadDirectory(item: NSArray) {
        for stuff in item {
            let userData = stuff as! Dictionary<NSString, AnyObject>
            var id = ""
            var name = ""
            var image = ""
            var city = ""
            var state = ""
            
            for (key, value) in userData {
                switch key {
                    case "id":
                        id = value as! String
                    case "name":
                        name = value as! String
                    case "image":
                        image = value as! String
                    case "city":
                        city = value as! String
                    case "state":
                        state = value as! String
                    default:
                        print("Error setting new directory information")
                }
            }
            
            let newDirectoryItem = StudentDirectoryItem(id: id)
            newDirectoryItem.name = name
            newDirectoryItem.image = image
            newDirectoryItem.city = city
            newDirectoryItem.state = state
            directoryItems.append(newDirectoryItem)
        }
    }
    
    func save(item: StudentDirectoryItem) {
        
        if !directoryItems.contains(item) {
            directoryItems.append(item)
        } else {
            return
        }
        
        // Get the path of the library file contents
        let dirpath: NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let path = dirpath.stringByAppendingPathComponent("DirectoryInformation.json")
        
        var dataToWrite: NSData!
        
        // Get all the class data converted to JSON, and append it to an array for writing
        do {
            var data = Array<AnyObject>()   // The array for writing
            for stuff in directoryItems {
                // For each person in the directory, add the JSON for that person's data
                data.appendContentsOf(stuff.createDictionary())
            }
            dataToWrite = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
        } catch {
            print("Error serializing data")
        }
        
        // Write the JSON to a file
        if let outputStream = NSOutputStream(toFileAtPath: path, append: false) {
            outputStream.open()
            outputStream.write(UnsafePointer(dataToWrite.bytes), maxLength: dataToWrite.length)
            outputStream.close()
        } else {
            print("Unable to open file")
        }
        
    }
    
    func saveAll(items: [StudentDirectoryItem]) {
        // If we're adding a bunch of items at once. For your convenience.
        for item in items {
            save(item)
        }
    }
    
}