//
//  TimelineTableViewCell.swift
//  FetchTweets
//
//  Created by Bruno Maia de Morais on 19/04/21.
//  Copyright © 2021 Bruno Maia de Morais. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareCell(tweet: Tweet, urlProfilePhoto: String) {
        self.tweetText.text = tweet.text
             
        if urlProfilePhoto != "" {
            self.profilePhoto.load(url: URL(string: urlProfilePhoto)!)
        }
        
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height/2
        self.profilePhoto.layer.borderColor = UIColor.blue.cgColor
        self.profilePhoto.layer.borderWidth = 2
    }

}
