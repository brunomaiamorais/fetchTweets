//
//  ApiRestTwitter.swift
//  FetchTweets
//
//  Created by Bruno Maia de Morais on 16/04/21.
//  Copyright © 2021 Bruno Maia de Morais. All rights reserved.
//

import Foundation

enum TweetError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJson
}


class ApiRestTwitter {
    
    private static let searchTweetsBasePath = "https://api.twitter.com/2/tweets/search/recent"
    private static let tweetByIdWithUserInfoBasePath = "https://api.twitter.com/1.1/statuses/show.json"
    private static let timelineByUserIdBasePath = "https://api.twitter.com/2/users/"
    private static let token = "AAAAAAAAAAAAAAAAAAAAACONOgEAAAAAKrtCs%2FaFouEXWbVPrjZFWyjbie4%3DKXqW73vSIF7KMWei7CxwA69qlxGpAsLcuKhqsVSTjxqUOK3Yrk"
    
    class func loadTweets(withWord word: String, maxResult: Int, onComplete: @escaping ([Tweet]) -> Void, onError: @escaping (TweetError) -> Void) {
        
        let queryItem = URLQueryItem(name: "query", value: word)
        let queryItem2 = URLQueryItem(name: "max_results", value: "\(maxResult)")
        
        guard var urlComponents = URLComponents(string: self.searchTweetsBasePath) else {
            onError(.url)
            return
        }
        urlComponents.queryItems = [queryItem, queryItem2]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue( "Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                
                if response.statusCode == 200 {
                      guard let data = data else {
                        onError(.noData)
                        return}
                    do {
                        let tweetData = try JSONDecoder().decode(TweetData.self, from: data)
                        onComplete(tweetData.data)
                    } catch {
                        onError(.invalidJson)
                        print(error.localizedDescription)
                    }
                }
            } else {
                onError(.taskError(error: error!))
            }           
        }).resume()
    }
    
    class func loadUserPhoto(tweetId: CLongLong, onComplete: @escaping (TweetSatus) -> Void, onError: @escaping (TweetError) -> Void) {
        let queryItem = URLQueryItem(name: "id", value: "\(tweetId)")
        
        guard var urlComponents = URLComponents(string: self.tweetByIdWithUserInfoBasePath) else {
            onError(.url)
            return
        }
        urlComponents.queryItems = [queryItem]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue( "Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
       URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                
                if response.statusCode == 200 {
                    guard let data = data else {
                        onError(.noData)
                        return}
                    
                    do {
                        let tweetUserInfo = try JSONDecoder().decode(TweetSatus.self, from: data)
                        onComplete(tweetUserInfo)
                    } catch {
                        onError(.invalidJson)
                    }
                }
            }
        }).resume()
    }
    
    class func loadUserTimeline(userId: CLongLong, onComplete: @escaping (TweetData) -> Void, onError: @escaping (TweetError) -> Void) {
        
        guard let urlComponents = URLComponents(string: self.timelineByUserIdBasePath + "\(userId)" + "/tweets") else {
            onError(.url)
            return
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue( "Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return}
                
                if response.statusCode == 200 {
                    guard let data = data else {
                        onError(.noData)
                        return}
                    
                    do {
                        let userTimeline = try JSONDecoder().decode(TweetData.self, from: data)
                        onComplete(userTimeline)
                    } catch {
                        onError(.invalidJson)
                    }
                }
            }
        }).resume()
    }
}
