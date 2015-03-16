//
//  conversationVC.swift
//  ChitChatterApp
//
//  Created by Tyler Askew on 1/6/15.
//  Copyright (c) 2015 Tyler Askew. All rights reserved.
//

import UIKit

// Global Variables
var otherName = ""

/*
 * Displays the conversation between the current user 
 * and the user that was selected in the usersVC.
*/
class conversationVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    // Outlets
    @IBOutlet weak var resultsScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomViewArea: UIView!
    
    var scrollViewOriginalY: CGFloat = 0
    var frameMessageOriginalY: CGFloat = 0
    
    let messageLabel = UILabel(frame: CGRectMake(5, 8, 200, 20))
    
    var messageX: CGFloat = 37.0
    var messageY: CGFloat = 26.0
    var frameX: CGFloat = 32.0
    var frameY: CGFloat = 21.0
    var imageX: CGFloat = 3
    var imageY: CGFloat = 3
    
    var messagesArr = [String]()
    var sendersArr = [String]()
    
    var myImage: UIImage? = UIImage()
    var otherImage: UIImage? = UIImage()
    
    var resultsImageFiles1 = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        // setting positions/sizes for the views and button
        resultsScrollView.frame = CGRectMake(0, 64, theWidth, theHeight - 114)
        resultsScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, resultsScrollView.frame.maxY, theWidth, 50)
        lineLabel.frame = CGRectMake(0, 0, theWidth, 1)
        messageTextView.frame = CGRectMake(2, 1, self.frameMessageView.frame.size.width - 52, 48)
        sendButton.center = CGPointMake(frameMessageView.frame.size.width - 30, 24)
        
        // saving original Y position of these views
        scrollViewOriginalY = self.resultsScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        self.title = otherName
        
        // setting placeholder text in the message text view
        messageLabel.text = "Type a message..."
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(messageLabel)
       
        // calls these functions once notifications have been received
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        // adding new gesture recognizer to the view
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultsScrollView.addGestureRecognizer(tapScrollViewGesture)
    }
    
    /*
     * Ends editing once view is touched.
    */
    func didTapScrollView() {
        self.view.endEditing(true)
    }
    
    /*
     * Determines whether to show default message text or not.
    */
    func textViewDidChange(textView: UITextView) {
        if (!messageTextView.hasText()) {
            self.messageLabel.hidden = false
        } else {
            self.messageLabel.hidden = true
        }
    }
    
    /*
     * Shows default message text once done editing text view.
    */
    func textViewDidEndEditing(textView: UITextView) {
        if (!messageTextView.hasText()) {
            self.messageLabel.hidden = false
        }
    }
    
    /*
     * This will move the screen contents up above the keyboard.
    */
    func keyboardWasShown(notification: NSNotification) {
        let dict: NSDictionary = notification.userInfo!
        let s: NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        let rect: CGRect = s.CGRectValue()
        
        // moving contents above keyboard (rect is the keyboard dimensions)
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear,
            animations: {
                self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
                self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
                
               var bottomOffset: CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            },
            completion: { (finished: Bool) in })
    }
    
    /*
     * Returns the screen contents back to original positions after
     * keyboard disappears.
    */
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear,
            animations: {
                self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY
                self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
                
                var bottomOffset: CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            },
            completion: { (finished: Bool) in })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Sets the both users' images and calls
     * the refreshResults method to display these.
    */
    override func viewDidAppear(animated: Bool) {
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        var objects = query.findObjects()
        
        self.resultsImageFiles1.removeAll(keepCapacity: false)
        
        // updating user information
        for object in objects {
            self.resultsImageFiles1.append(object["profilePic"] as PFFile)
            self.resultsImageFiles1[0].getDataInBackgroundWithBlock({
                (imageData: NSData!, error: NSError!) -> Void in
                if (error == nil) {
                    self.myImage = UIImage(data: imageData)
                    
                    var query2 = PFQuery(className: "_User")
                    query2.whereKey("username", equalTo: otherName)
                    var objects2 = query2.findObjects()
                    
                    self.resultsImageFiles2.removeAll(keepCapacity: false)
                    
                    for object in objects2 {
                        self.resultsImageFiles2.append(object["profilePic"] as PFFile)
                        self.resultsImageFiles2[0].getDataInBackgroundWithBlock({
                            (imageData: NSData!, error: NSError!) -> Void in
                            if (error == nil) {
                                self.otherImage = UIImage(data: imageData)
                                self.refreshResults()
                            }
                        })
                    }
                }
            })
        }
    }
    
    /*
     * Outputs the messages for both the sender and recipient. Also
     * prints out their profile photo.
    */
    func refreshResults() {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        frameX = 32.0
        frameY = 21.0
        imageX = 3
        imageY = 3
        
        messagesArr.removeAll(keepCapacity: false)
        sendersArr.removeAll(keepCapacity: false)
        
        let innerPred1 = NSPredicate(format: "sender = %@ AND receiver = %@", userName, otherName)
        let innerQuery1: PFQuery = PFQuery(className: "Messages", predicate: innerPred1)
        
        let innerPred2 = NSPredicate(format: "sender = %@ AND receiver = %@", otherName, userName)
        let innerQuery2: PFQuery = PFQuery(className: "Messages", predicate: innerPred2)
        
        var mainQuery = PFQuery.orQueryWithSubqueries([innerQuery1, innerQuery2])
        mainQuery.addAscendingOrder("createdAt")
        
        mainQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                for object in objects {
                    self.sendersArr.append(object.objectForKey("sender") as String)
                    self.messagesArr.append(object.objectForKey("message") as String)
                }
                
                for subView in self.resultsScrollView.subviews {
                    subView.removeFromSuperview()
                }
                
                // adding messages to scroll view from both the sender and recipient
                for (var i = 0; i < self.messagesArr.count; i++) {
                    if (self.sendersArr[i] == userName) {
                        var messageLabel: UILabel = UILabel()
                        messageLabel.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width - 94, CGFloat.max)
                        messageLabel.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLabel.textAlignment = NSTextAlignment.Left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLabel.textColor = UIColor.whiteColor()
                        messageLabel.text = self.messagesArr[i]
                        messageLabel.sizeToFit()
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = (self.resultsScrollView.frame.size.width - self.messageX) - messageLabel.frame.size.width
                        messageLabel.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLabel)
                        
                        var frameLabel = UILabel()
                        frameLabel.frame.size = CGSizeMake(messageLabel.frame.size.width + 10, messageLabel.frame.size.height + 10)
                        frameLabel.frame.origin.x = (self.resultsScrollView.frame.size.width - self.frameX) - frameLabel.frame.size.width
                        frameLabel.frame.origin.y = self.frameY
                        frameLabel.backgroundColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLabel)
                        self.frameY += frameLabel.frame.size.height + 20
                        
                        self.messageY += frameLabel.frame.size.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = self.myImage
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = (self.resultsScrollView.frame.size.width - self.imageX) - img.frame.size.width
                        img.frame.origin.y = self.imageY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width / 2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imageY += frameLabel.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                    } else {
                        var messageLabel: UILabel = UILabel()
                        messageLabel.frame = CGRectMake(0, 0, self.resultsScrollView.frame.size.width - 94, CGFloat.max)
                        messageLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLabel.textAlignment = NSTextAlignment.Left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLabel.textColor = UIColor.blackColor()
                        messageLabel.text = self.messagesArr[i]
                        messageLabel.sizeToFit()
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = self.messageX
                        messageLabel.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLabel)
                        self.messageY += self.messageLabel.frame.size.height + 30
                        
                        var frameLabel = UILabel()
                        frameLabel.frame = CGRectMake(self.frameX, self.frameY, messageLabel.frame.size.width + 10, messageLabel.frame.size.height + 10)
                        frameLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLabel)
                        self.frameY += frameLabel.frame.size.height + 20
                        
                        var img: UIImageView = UIImageView()
                        img.image = self.otherImage
                        img.frame = CGRectMake(self.imageX, self.imageY, 34, 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width / 2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imageY += frameLabel.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                    }
                    
                    var bottomOffset: CGPoint = CGPointMake(0, self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                    self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
                }
            }
        })
    }
    
    /*
     * Handles the action of sending a user a message.
    */
    @IBAction func sendButtonClicked(sender: AnyObject) {
        if (messageTextView.text == "") {
            println("Nothing has been typed.")
        } else {
            var messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = userName
            messageDBTable["receiver"] = otherName
            messageDBTable["message"] = self.messageTextView.text
            messageDBTable.saveInBackgroundWithBlock({
                (success: Bool!, error: NSError!) -> Void in
                if (success == true) {
                    println("Message sent!")
                    self.messageTextView.text = ""
                    self.messageLabel.hidden = false
                    self.refreshResults()
                }
            })
        }
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
