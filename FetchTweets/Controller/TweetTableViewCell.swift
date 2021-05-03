//
//  TweetTableViewCell.swift
//  FetchTweets
//
//  Created by Bruno Maia de Morais on 18/04/21.
//  Copyright © 2021 Bruno Maia de Morais. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var tweetText: UILabel!

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

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
