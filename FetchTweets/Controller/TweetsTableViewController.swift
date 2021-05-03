//
//  TweetsTableViewController.swift
//  FetchTweets
//
//  Created by Bruno Maia de Morais on 17/04/21.
//  Copyright © 2021 Bruno Maia de Morais. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tweets: [Tweet] = []
    var userInfo: [TweetUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetsCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = self.tweets[indexPath.row]
        var urlProfilePhoto: String = ""
        
        if indexPath.row < self.userInfo.count {
            urlProfilePhoto = self.userInfo[indexPath.row].profile_image_url
        }
        
        tweetsCell.prepareCell(tweet: tweet, urlProfilePhoto: urlProfilePhoto)
        
        return tweetsCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationViewController = segue.destination as! TimelineTableViewController
         destinationViewController.userInfo = self.userInfo[self.tableView.indexPathForSelectedRow!.row]
    }

}


extension TweetsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.userInfo.removeAll()
        
        guard let searchKeyword = searchBar.text else {return}
        self.searchBar.resignFirstResponder()
        
        ApiRestTwitter.loadTweets(withWord: searchKeyword, maxResult: 10, onComplete: { (tweets) in
            self.tweets = tweets
            
            for tweet in tweets {
                ApiRestTwitter.loadUserPhoto(tweetId: CLongLong(tweet.id)!, onComplete: { (tweetStatus) in
                    self.userInfo.append(tweetStatus.user)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }, onError: { (error) in
                    print(error)
                })
            }
            
        }) { (error) in
            print(error)
        }
    }
}
