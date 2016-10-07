//
//  LoginViewController.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/6/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let wallSegue = "showViewController"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func logInPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userTextField.text, password: passwordTextField.text) { user, error in
            if user != nil {
                self.performSegueWithIdentifier(self.wallSegue, sender: nil)
            } else if let error = error {
                self.showErrorView(error)
                
                //println("Error logging in")
            }
        }
    }
}
