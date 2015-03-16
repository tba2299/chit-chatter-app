//
//  loginVC.swift
//  ChitChatterApp
//
//  Created by Tyler Askew on 1/5/15.
//  Copyright (c) 2015 Tyler Askew. All rights reserved.
//

import UIKit

/*
 * Login screen where users sign into their accounts.
*/
class loginVC: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // keeping width and height constant
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        // positioning all ui components
        welcomeLabel.center = CGPointMake(theWidth / 2, 130)
        usernameTextField.frame = CGRectMake(16, 200, theWidth - 32, 30)
        passwordTextField.frame = CGRectMake(16, 240, theWidth - 32, 30)
        loginButton.center = CGPointMake(theWidth / 2, 330)
        registerButton.center = CGPointMake(theWidth / 2, 375)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Searches Parse database to find user with specified
     * username and password. If not found, produce an error.
    */
    @IBAction func loginButtonClicker(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text)
        {
            (user:PFUser!, logInError:NSError!) -> Void in
            if (logInError == nil) {
                println("Successful Login!")
                self.performSegueWithIdentifier("loginToUsersVC", sender: self)
            } else {
                println("Not registered or wrong credentials.")
            }
        }
    }
    
    /*
    * Closes the keyboard upon hitting the return key.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    /*
    * Closes keyboard when screen outside keyboard is touched.
    */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    /*
    * Hides the back button in this controller.
    */
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
