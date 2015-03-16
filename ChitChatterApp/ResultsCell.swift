//
//  ResultsCell.swift
//  ChitChatterApp
//
//  Created by Tyler Askew on 1/6/15.
//  Copyright (c) 2015 Tyler Askew. All rights reserved.
//

import UIKit

/*
 * Represents the cells in the table in usersVC.
*/
class ResultsCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theWidth = UIScreen.mainScreen().bounds.width
        contentView.frame = CGRectMake(0, 0, theWidth, 120)
        
        profilePhoto.center = CGPointMake(60, 60)
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width / 2
        profilePhoto.clipsToBounds = true
        
        usernameLabel.center = CGPointMake(230, 55)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
