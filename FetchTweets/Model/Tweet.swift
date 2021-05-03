//
//  Tweet.swift
//  FetchTweets
//
//  Created by Bruno Maia de Morais on 16/04/21.
//  Copyright © 2021 Bruno Maia de Morais. All rights reserved.
//

import Foundation

class Tweet: Codable {
    var id: String
    var text: String
}

class TweetErrors: Codable {
    var errors: [TweetParams]
    var title: String
    var detail: String
    var type: String
}

class TweetParams: Codable {
    var parameters: TweetQuery
    var message: String
}

class TweetQuery: Codable {
    var query: [String]
}

class TweetData: Codable {
    var data: [Tweet]
}

class TweetSatus: Codable {
    var user: TweetUser
}

class TweetUser: Codable {
    var id: CLongLong
    var screen_name: String
    var profile_image_url: String
}








