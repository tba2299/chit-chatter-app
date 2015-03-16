//
//  registerVC.swift
//  ChitChatterApp
//
//  Created by Tyler Askew on 1/5/15.
//  Copyright (c) 2015 Tyler Askew. All rights reserved.
//

import UIKit

/*
 * Displays the register screen for a new user.
*/
class registerVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var addProfilePhotoButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // saving width and height as constants
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        // setting positions of ui components
        profilePhoto.center = CGPointMake(theWidth / 2, 140)
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width / 2
        profilePhoto.clipsToBounds = true
        addProfilePhotoButton.center = CGPointMake(self.profilePhoto.frame.maxX + 50, 140)
        usernameTextField.frame = CGRectMake(16, 230, theWidth - 32, 30)
        emailTextField.frame = CGRectMake(16, 270, theWidth - 32, 30)
        passwordTextField.frame = CGRectMake(16, 310, theWidth - 32, 30)
        registerButton.center = CGPointMake(theWidth / 2, 380)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Handles the action of the add photo button by
     * allowing a user to add a profile picture from their library.
    */
    @IBAction func addPhotoButton(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    /*
     * Changes the user's profile picture.
    */
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profilePhoto.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
     * Closes the keyboard upon hitting the return key.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
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
     * Moves the text field up so that the keyboard
     * is not covering it.
    */
    func textFieldDidBeginEditing(textField: UITextField) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if (UIScreen.mainScreen().bounds.height == 568 &&
            textField == self.passwordTextField) {
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear,
                    animations: {
                        self.view.center = CGPointMake(theWidth / 2, theHeight / 2 - 40)
                },
                    completion: {
                        (finished:Bool) in
                })
        }
    }
    
    /*
    * Returns the text field to its original position
    * once it has been edited.
    */
    func textFieldDidEndEditing(textField: UITextField) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if (UIScreen.mainScreen().bounds.height == 568 &&
            textField == self.passwordTextField) {
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear,
                    animations: {
                        self.view.center = CGPointMake(theWidth / 2, theHeight / 2)
                    },
                    completion: {
                        (finished:Bool) in
                })
        }
    }

    /*
     * Creating a new user with specified information
     * and adding it to Parse database.
    */
    @IBAction func registerUserButton(sender: AnyObject) {
        var user = PFUser()
        user.username = usernameTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        
        let imageData = UIImagePNGRepresentation(self.profilePhoto.image)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData)
        user["profilePic"] = imageFile
    
        user.signUpInBackgroundWithBlock({
            (succeeded:Bool!, registerError:NSError!) -> Void in
            if (registerError == nil) {
                println("Successfully Registered!")
                self.performSegueWithIdentifier("registerToUsersVC", sender: self)
            } else {
                println("Unable to register.")
            }
        })
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
