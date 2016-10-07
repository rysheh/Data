//
//  OutputTableViewController.swift
//  DATA
//
//  Created by Ryan Sheh on 6/24/15.
//  Copyright (c) 2015 Ryan Sheh. All rights reserved.
//

import UIKit

class OutputTableViewController: UITableViewController {
    
    //array for categories in tableviewcontroller
    var categories = [
        "Who", "What", "When", "Where", "Why"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.popToRootViewControllerAnimated(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier: String = "CategoryCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = categories[indexPath.row]

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var chosenCategoryViewController: ChosenCategoryTableViewController = segue.destinationViewController as! ChosenCategoryTableViewController
        
        let selectedIndexPath = tableView.indexPathForSelectedRow()
        var selectedCategory: String = categories[selectedIndexPath!.row]
        chosenCategoryViewController.selectedCategory = selectedCategory
    }
}
