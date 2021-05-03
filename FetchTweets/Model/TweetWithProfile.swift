//
//  TweetWithProfile.swift
//  FetchTweets
//
//  Created by Bruno Maia de Morais on 18/04/21.
//  Copyright © 2021 Bruno Maia de Morais. All rights reserved.
//

import Foundation


class TweetWithProfile {
    let tweetText: String!
    let urlTweetProfilePhoto: String!
    
    init(tweetText: String, urlTweetProfilePhoto: String) {
        self.tweetText = tweetText
        self.urlTweetProfilePhoto = urlTweetProfilePhoto
    }
}
