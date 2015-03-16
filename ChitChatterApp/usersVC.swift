//
//  usersVC.swift
//  ChitChatterApp
//
//  Created by Tyler Askew on 1/6/15.
//  Copyright (c) 2015 Tyler Askew. All rights reserved.
//

import UIKit

// Global Variables
var userName = ""

/*
 * Screen that displays all of the users of the application so that
 * the current user may have conversations with them.
*/
class usersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var resultsTable: UITableView!
    
    // Arrays
    var resultsUsernameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, theHeight, theHeight - 64)
        userName = PFUser.currentUser().username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Hides the back button in this controller.
    */
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    /*
     * Resets the results table with the most current user information.
    */
    override func viewDidAppear(animated: Bool) {
        let pred = NSPredicate(format: "username != %@", userName)
        var query = PFQuery(className: "_User", predicate: pred)
        var objects = query.findObjects()
        
        self.resultsUsernameArray.removeAll(keepCapacity: false)
        self.resultsImageFiles.removeAll(keepCapacity: false)
        
        // refilling arrays with most recent information
        for object in objects {
            self.resultsUsernameArray.append(object.username)
            self.resultsImageFiles.append(object["profilePic"] as PFFile)
            
            self.resultsTable.reloadData()
        }
    }
    
    /*
     * Returns number of rows in the table.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }
    
    /*
     * Returns the height of an individual cell in the table.
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    /*
     * Sets the cell with the user information.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ResultsCell = tableView.dequeueReusableCellWithIdentifier("Cell") as ResultsCell
        cell.usernameLabel.text = self.resultsUsernameArray[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock({
            (imageData: NSData!, error: NSError!) -> Void in
            if (error == nil) {
                let image = UIImage(data: imageData)
                cell.profilePhoto.image = image
            }
        })
        
        return cell
    }
    
    /*
     * Handles action of user selecting another user to send
     * a message to.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as ResultsCell
        otherName = cell.usernameLabel.text!
        self.performSegueWithIdentifier("usersToConversationVC", sender: self)
    }
    
    /*
     * Logs a user out of the application and navigates
     * back to the welcome page.
    */
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
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
