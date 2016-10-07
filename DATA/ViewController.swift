//
//  ViewController.swift
//  DATA
//
//  Created by Ryan Sheh on 6/24/15.
//  Copyright (c) 2015 Ryan Sheh. All rights reserved.
//

import UIKit
import Parse

class ViewController: PFQueryTableViewController {

    //@IBOutlet weak var backgroundImage: UIImageView!
    let info = Info.sharedInstance
    
    var timelineData = [String]()
    
    override func viewDidLoad() {
        //backgroundImage.image = UIImage(named: ("mountainwater"))
        
        //self.info.loadFile()
        //self.info.countAndRemoveDuplicatesWithinArrayOfInformation()
        //loadParseData()
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
*/
    
    /*
    func loadParseData() {
        let query = PFQuery(className: "UserInput")
       
        query.whereKey("Name", equalTo: "John")
        query.whereKey("Score", greaterThan: 1000)
     
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                println("Successfully retrieved: \(objects)")
            } else {
                println("Error retrieiving data from Parse")
            }
        }
    }
    */
    
    override func queryForTable() -> PFQuery {
        let query = Info.query()
        return query!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // 1
        let cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) as! InfoTableViewCell
        
        // 2
        let info = object as! Info
        
        // 3
        //cell.postImage.file = info.image
        //cell.postImage.loadInBackground(nil) { percent in
        //    cell.progressView.progress = Float(percent)*0.01
        //    println("\(percent)%")
        //}
        
        // 4
        let creationDate = info.createdAt
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM yyyy"
        let dateString = dateFormatter.stringFromDate(creationDate!)
        
        
        //username
        if let username = info.user.username {
            cell.createdByLabel.text = username
        } else {
            cell.createdByLabel.text = "Anonymous"
        }
        
        cell.createdByLabel.text = info.user.username
        cell.timeLabel.text = info.time
        cell.descriptionLabel.text = info.info
        
        return cell
    }
}

