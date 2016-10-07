//
//  ChosenCategoryTableViewController.swift
//  DATA
//
//  Created by Ryan Sheh on 7/3/15.
//  Copyright (c) 2015 Ryan Sheh. All rights reserved.
//

import UIKit

/*  
    If you add another category, you need to
    - edit the tableView cells switch case statement
*/

class ChosenCategoryTableViewController: UITableViewController {
    let info = Info.sharedInstance

    var tempArray = [String]()
    var selectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var tableCellCount = 0
        
        switch selectedCategory {
        case "Who":
             tableCellCount = self.info.arrayOfNames.count
        case "What":
            tableCellCount = self.info.arrayOfActivities.count
        case "When":
            tableCellCount = self.info.arrayOfDates.count
        default:
            println("Error")
        }
        return tableCellCount
    }
    
    //labels textlabel and detaillabel of all cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIdentifier: String = "SubCategoryCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let numberOfAccounts = self.info.arrayOfInformation.count/self.info.numberOfCategories
        for var i = 0; i < numberOfAccounts; i++ {
            var quantity = 0
            
            switch selectedCategory {
                case "Who":
                    cell.textLabel?.text = self.info.arrayOfNames[indexPath.row]
                    
                    for var j = 0; j < self.info.arrayOfInformation.count; j++ {
                        if(self.info.arrayOfInformation[j].names == self.info.arrayOfNames[indexPath.row]) {
                            quantity = self.info.arrayOfInformation[j].quantity.nameCount
                        }
                    }
                
                case "What":
                    cell.textLabel?.text = self.info.arrayOfActivities[indexPath.row]
                
                    for var j = 0; j < self.info.arrayOfInformation.count; j++ {
                        if(self.info.arrayOfInformation[j].nameOfActivity == self.info.arrayOfActivities[indexPath.row]) {
                            quantity = self.info.arrayOfInformation[j].quantity.nameOfActivityCount
                        }
                    }
                case "When":
                    //println()
                    cell.textLabel?.text = self.info.arrayOfDates[indexPath.row]
                
                default:
                    println("Error")
            }
            
            cell.detailTextLabel?.text = quantity.description
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var resultsViewController: ResultsViewController = segue.destinationViewController as! ResultsViewController
        
        var tempString: String = ""
        let selectedIndexPath = tableView.indexPathForSelectedRow()
        
        switch selectedCategory {
        case "Who":
            tempString = self.info.arrayOfNames[selectedIndexPath!.row]
            
        case "What":
            tempString = self.info.arrayOfActivities[selectedIndexPath!.row]
            
        case "When":
            tempString = self.info.arrayOfDates[selectedIndexPath!.row]
            
        default:
            println("Error")
        }
        
        resultsViewController.chosenOption = tempString
    }
}
