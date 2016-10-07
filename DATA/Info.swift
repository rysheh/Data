//
//  Info.swift
//  DATA
//
//  Created by Ryan Sheh on 7/12/15.
//  Copyright (c) 2015 Ryan Sheh. All rights reserved.
//

import UIKit
import Parse

internal class Info: PFObject {
    //ALLOWING SHARED INSTANCES
    class var sharedInstance: Info {
        struct Static {
            static var instance: Info?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Info()
        }
        
        return Static.instance!
    }
    
    //INFO CATEGORIES
    var names: String = ""
    var nameOfActivity: String = ""
    var date = timeClass()
    var location = locationClass()
    var why: String = ""
    
    //ARRAYS
    var arrayOfInformation = [Info] ()
    
    var arrayOfNames = [String] ()
    var arrayOfActivities = [String] ()
    var arrayOfDates = [String] ()
    var arrayOfLocations = [String] ()
    
    var quantity = counter()
    var numberOfCategories = 3
    
    //PFObjects (NSManaged allows key/value pairings)
    @NSManaged var user: PFUser
    //@NSManaged var info: PFFile
    @NSManaged var info: String?
    @NSManaged var time: String?
    
    //Initializers
    init(user: PFUser, description: String?, time: String?) {
        super.init()
        
        self.user = user
        //self.info = info
        self.info = description
        self.time = time
    }
    
    
    override init() {
        super.init()
    }
    
    internal func loadFile() {
        arrayOfInformation = [Info]()

        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as! NSURL
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("file.txt")
        
        //reading
        let currentTextOnFile = String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding, error: nil)
        
        var arrayOfStrings = [String] ()
        arrayOfStrings = currentTextOnFile!.componentsSeparatedByString("\n")
        
        for var i = 0; i < arrayOfStrings.count/self.numberOfCategories; i++ {
            var tempInfo = Info()
            tempInfo.names = arrayOfStrings[self.numberOfCategories * i]
            tempInfo.nameOfActivity = arrayOfStrings[self.numberOfCategories * i + 1]
            tempInfo.date.description = arrayOfStrings[self.numberOfCategories * i + 2]
            tempInfo.location.description = arrayOfStrings[self.numberOfCategories * i + 3]
            tempInfo.why = arrayOfStrings[self.numberOfCategories * i + 4]
            //add future categories into here
            
            arrayOfInformation.append(tempInfo)
        }
        
        println("Updated file.")
    }
    
    
    internal func countAndRemoveDuplicatesWithinArrayOfInformation() {
        //reinitialize counters
        for(var i = 0; i < self.arrayOfInformation.count; i++) {
            self.arrayOfInformation[i].quantity.nameCount = 0
            self.arrayOfInformation[i].quantity.nameOfActivityCount = 0
            self.arrayOfInformation[i].quantity.nameOfLocation = 0
            //ADD MORE
        }

        //counts duplicates
        for(var i = 0; i < self.arrayOfInformation.count; i++) {
            for(var j = 0; j < self.arrayOfInformation.count; j++) {
                if(self.arrayOfInformation[i].names == self.arrayOfInformation[j].names) {
                    self.arrayOfInformation[i].quantity.nameCount++
                }
                if(self.arrayOfInformation[i].nameOfActivity == self.arrayOfInformation[j].nameOfActivity) {
                    self.arrayOfInformation[i].quantity.nameOfActivityCount++
                }
                //add more
            }
        }
        
        //create arrays without duplicates for each category
        for(var i = 0; i < self.arrayOfInformation.count; i++) {
            var nameExists = false
            var nameOfActivityExists = false
            
            //input arrayOfNames
            for(var j = 0; j < self.arrayOfNames.count; j++) {
                if(self.arrayOfInformation[i].names == self.arrayOfNames[j]) {
                    nameExists = true
                }
            }
            if(nameExists == false) {
                self.arrayOfNames.append(self.arrayOfInformation[i].names)
            }
            
            //input arrayOfActivities
            for(var j = 0; j < self.arrayOfActivities.count; j++) {
                if(self.arrayOfInformation[i].nameOfActivity == self.arrayOfActivities[j]) {
                    nameOfActivityExists = true
                }
            }
            if(nameOfActivityExists == false) {
                self.arrayOfActivities.append(self.arrayOfInformation[i].nameOfActivity)
            }
            
            //input arrayOfDates
            self.arrayOfDates.append(self.arrayOfInformation[i].date.description)
        }
    }
    
    internal func dateDescriptionBreakDown() {
        let dateAndTimeArray = self.date.description.componentsSeparatedByString(",")
        var monthAndDay = dateAndTimeArray[0]
        
        let monthAndDayArray = monthAndDay.componentsSeparatedByString(" ")
        self.date.month = monthAndDayArray[0]
        self.date.day = monthAndDayArray[1]
        self.date.year = dateAndTimeArray[1]
        
        var time = dateAndTimeArray[2]
        let timeArray = time.componentsSeparatedByString(":")
        self.date.hour = timeArray[0]
        self.date.minute = timeArray[1]
        //info.date.seconds
        
        var tempArray = time.componentsSeparatedByString(" ")
        self.date.timeOfDay = tempArray[2]
    }
    
    internal func locationDescriptionBreakDown() {
        let addressArray = self.location.description.componentsSeparatedByString(" ")
        
        self.location.locality = addressArray[0]
        self.location.postalCode = addressArray[1]
        self.location.administrativeArea = addressArray[2]
        self.location.country = addressArray[3]
    }
    
    //returns and sorts queries
    override class func query() -> PFQuery? {
        //1
        let query = PFQuery(className: Info.parseClassName())
        //2
        query.includeKey("user")
        //3
        query.orderByDescending("createdAt")
        return query
    }
}

internal class counter {
    var nameCount = 0
    var nameOfActivityCount = 0
    var nameOfLocation = 0
    //add more
}

internal class timeClass {
    var description: String = ""
    var month: String = ""
    var day: String = ""
    var year: String = ""
    var hour: String = ""
    var minute: String = ""
    var seconds: String = ""
    
    var timeOfDay: String = ""
}

internal class locationClass {
    var description: String = ""
    var locality: String = ""
    var postalCode: String = ""
    var administrativeArea: String = ""
    var country: String = ""
}

//Extension containing two required PFSubclassing required protocol methods
extension Info: PFSubclassing {
    // Table view delegate methods here
    // Set the name of the class as seen in backend methods
    class func parseClassName() -> String {
        return "UserInput"
    }
    
    // Inform Parse you intend to use this subclass for all objects with class type Info
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}
