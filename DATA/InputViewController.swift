//
//  InputViewController.swift
//  DATA
//
//  Created by Ryan Sheh on 6/24/15.
//  Copyright (c) 2015 Ryan Sheh. All rights reserved.
//

/*
    If you add future categories:
    -   edit writeToFile function
    -   add reset condition in resetInformation()
    -   edit saveToArray()

*/

import UIKit
import CoreLocation
import Parse

class InputViewController: UIViewController, CLLocationManagerDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textFieldNames: UITextField!
    @IBOutlet weak var previousView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textFieldNameOfLocation: UITextField!
    @IBOutlet weak var textFieldNameOfActivity: UITextField!
    @IBOutlet weak var addressTextField: UIDatePicker!
    @IBOutlet weak var whyPicker: UIPickerView!
    
    let info = Info.sharedInstance
    var tempDate = NSDate()
    let newLine: String = "\n"
    let space: String = " "
    let locationManager = CLLocationManager()
    var placeMarkExists: Bool = false
    let pickerData = ["Food", "Fun", "Academics", "Exercise", "Errands", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()

        //disallowing currentdate to be in the future
        let currentDate = NSDate()
        datePicker.maximumDate = currentDate
        datePicker.timeZone = NSTimeZone.defaultTimeZone()
        
        self.whyPicker.dataSource = self
        self.whyPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //differentiates between current time and previous time
    @IBAction func indexChanged(sender: AnyObject)
    {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            previousView.hidden = true
        case 1:
            previousView.hidden = false
        default:
            break;
        }
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        inputWho()
        inputWhat()
        inputWhen()
        inputWhere()
        
        if(placeMarkExists) {
            //writeToFile()
            saveToParse()
            resetInformation()
        }
        else {
            inputWhere()
        }
    }
    
    private func inputWho() {
        //IF TEXTFIELD IS EMPTY, IT IS THE USER
        if(textFieldNames.text == "") {
            //temporary input
            let userName = "Ryan Sheh" //only temporary
            info.names = userName
        }
        else {
            info.names = textFieldNames.text
        }
    }
    
    private func inputWhat() {
        var nameOfActivity = textFieldNameOfActivity.text
        
        if(nameOfActivity == "") {
            println("Empty name of activity.")
        }
        else {
        
            let stringLength = count(nameOfActivity) // Since swift1.2 `countElements` became `count`
            let subStringForEd = stringLength - 2
            let lastTwoCharacters = nameOfActivity.substringFromIndex(nameOfActivity.endIndex.predecessor().predecessor())
        
            let subStringForIng = stringLength - 3
            let lastThreeCharacters = nameOfActivity.substringFromIndex(nameOfActivity.endIndex.predecessor().predecessor().predecessor())
            //ED AND ING WORKS EXCEPT TOO MANY IRREGULAR VERBS TO INCLUDE
            /*
            if(lastTwoCharacters == "ed") {
                var edString = nameOfActivity.rangeOfString("ed", options: .BackwardsSearch)?.startIndex
                var stringWithoutEd = nameOfActivity.substringToIndex(edString!)
                tempInfo.nameOfActivity = stringWithoutEd
            }
            else if(lastThreeCharacters == "ing") {
                var ingString = nameOfActivity.rangeOfString("ing", options: .BackwardsSearch)?.startIndex
                var stringWithoutIng = nameOfActivity.substringToIndex(ingString!)
                tempInfo.nameOfActivity = stringWithoutIng
            }
            else {
                tempInfo.nameOfActivity = textFieldNameOfActivity.text
            }
            */
        info.nameOfActivity = textFieldNameOfActivity.text
        }
    }
    
    //WHEN
    private func inputWhen() {
        if(segmentedControl == 0) {
            info.date.description = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }
        else {
            info.date.description = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }
        
        info.dateDescriptionBreakDown()
    }
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        info.date.description = NSDateFormatter.localizedStringFromDate(datePicker.date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        info.dateDescriptionBreakDown()
    }
  
    //WHERE
    @IBAction func inputWhere(/*sender: AnyObject*/) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.saveLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func saveLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            info.location.description = (
                locality + space +
                postalCode + space +
                administrativeArea + space +
                country)
        }
        
        info.locationDescriptionBreakDown()
        placeMarkExists = true
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    //INPUT WHY
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        info.why = pickerData[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }

    /*
    private func writeToFile() {
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as! NSURL
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("file.txt")
        
        //reading
        let currentTextOnFile = String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding, error: nil)
        
        var newTextToAddOnFile: String =
            info.names +
                newLine +
                
            info.nameOfActivity +
                newLine +
                
            info.date.description +
                newLine +
        
            info.location.description +
                newLine +
        
            info.why +
                newLine
        
            //add future categories here

        let text = newTextToAddOnFile + currentTextOnFile!

        //writing
        text.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        println("Written to file.")
    }
    */
    
    func saveToParse()
    {
        println(info.why)
        
        let tempString: String = info.nameOfActivity + " w/ " + info.names + " @ " + info.location.administrativeArea
        
        let tempTime: String = info.date.hour + ":" + info.date.minute
        
        //1
        let infoPost = Info(user: PFUser.currentUser()!, description: tempString, time: tempTime)
        infoPost.setObject(info.names, forKey: "Who")
        infoPost.setObject(info.nameOfActivity, forKey: "What")
        infoPost.setObject(tempTime, forKey: "When")
        infoPost.setObject(info.location.administrativeArea, forKey: "Where")
        infoPost.setObject(info.why, forKey:"Why")
        
        //2
        infoPost.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                //4
                if let errorMessage = error?.userInfo?["error"] as? String {
                    self.showErrorView(error!)
                }
            }
        }
    }
    
    private func resetInformation() {
        textFieldNames.text = ""
        textFieldNameOfActivity.text = ""
        
        let currentDate = NSDate()
        datePicker.date = currentDate
        datePicker.timeZone = NSTimeZone.defaultTimeZone()
        
        placeMarkExists = false
        
        //add future categories here
        
        println("Reset input conditions.")
    }

}
