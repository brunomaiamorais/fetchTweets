//
//  TimelineTableViewController.swift
//  FetchTweets
//
//  Created by Bruno Maia de Morais on 19/04/21.
//  Copyright © 2021 Bruno Maia de Morais. All rights reserved.
//

import UIKit

class TimelineTableViewController: UITableViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var username: UILabel!    
    
    var userInfo: TweetUser?
    var userTweets: [Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ApiRestTwitter.loadUserTimeline(userId: (userInfo?.id)!, onComplete: { (timelineTweets) in
            self.userTweets = timelineTweets.data
            self.profilePhoto.load(url: URL(string: (self.userInfo?.profile_image_url)!)!)
            DispatchQueue.main.async {
                self.username.text = self.userInfo?.screen_name
                self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.height/2
                self.profilePhoto.layer.borderColor = UIColor.blue.cgColor
                self.profilePhoto.layer.borderWidth = 2
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userTweets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimelineTableViewCell
        
        let tweet = self.userTweets[indexPath.row]
        var urlProfilePhoto: String = ""
        
        if indexPath.row < self.userTweets.count {
            
            if self.userInfo != nil {
                urlProfilePhoto = self.userInfo!.profile_image_url
            }
            
        }
        
        timelineCell.prepareCell(tweet: tweet, urlProfilePhoto: urlProfilePhoto)

        return timelineCell
    }
}
