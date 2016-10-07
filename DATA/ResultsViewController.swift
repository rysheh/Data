//
//  ResultsViewController.swift
//  DATA
//
//  Created by Ryan Sheh on 7/14/15.
//  Copyright (c) 2015 Ryan Sheh. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var leftResultsTextLabel: UILabel!
    @IBOutlet weak var rightResultsTextLabel: UILabel!
    let info = Info.sharedInstance
    var chosenOption: String = ""
    let newLine = "\n"

    var tempArray = [String]()

    override func viewDidLoad() {
        pullUpRelevantInfo()
        showResults()
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func pullUpRelevantInfo() {
        for var i = 0; i < self.info.arrayOfNames.count; i++ {
            if(chosenOption == self.info.arrayOfNames[i]) {
                showActivities()
                //show other
            }
        }
        for var i = 0; i < self.info.arrayOfActivities.count; i++ {
            if(chosenOption == self.info.arrayOfActivities[i]) {
                showNames()
                //show other
            }
        }
    }
    
    private func showNames() {
        for var i = 0; i < self.info.arrayOfInformation.count; i++ {
            if(self.info.arrayOfInformation[i].nameOfActivity == chosenOption) {
                tempArray.append(self.info.arrayOfInformation[i].names)
            }
        }
    }
    
    private func showActivities() {
        for var i = 0; i < self.info.arrayOfInformation.count; i++ {
            if(self.info.arrayOfInformation[i].names == chosenOption) {
                tempArray.append(self.info.arrayOfInformation[i].nameOfActivity)
            }
        }
    }
    
    private func showResults() {
        var tempString: String = ""
        tempString = "Info: "

        for var i = 0; i < tempArray.count; i++ {
            tempString = tempString + tempArray[i] + newLine
        }
        
        leftResultsTextLabel.text = tempString
    }
}
