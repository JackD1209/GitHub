//
//  GitHubModel.swift
//  GitHub
//
//  Created by Đoàn Minh Hoàng on 11/25/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import Foundation
import AFNetworking

private let reposUrl = "https://api.github.com/search/repositories"
private let clientId: String? = "308ba5d8599867228a7f"
private let clientSecret: String? = "3352641a113547452231c74de9932007ba633786"

// Model class that represents a GitHub repository
class GitHubModel: CustomStringConvertible {
    
    var name = ""
    var ownerHandle = ""
    var ownerAvatarURL = ""
    var stars = 0
    var forks = 0
    var repoDescription = ""
    var language = ""
    
    // Initializes a GitHubRepo from a JSON dictionary
    init(jsonResult: NSDictionary) {
        if let name = jsonResult["name"] as? String {
            self.name = name
        }
        
        if let stars = jsonResult["stargazers_count"] as? Int {
            self.stars = stars
        }
        
        if let forks = jsonResult["forks_count"] as? Int {
            self.forks = forks
        }
        
        if let owner = jsonResult["owner"] as? NSDictionary {
            if let ownerHandle = owner["login"] as? String {
                self.ownerHandle = ownerHandle
            }
            if let ownerAvatarURL = owner["avatar_url"] as? String {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }
        
        if let description = jsonResult["description"] as? String {
            self.repoDescription = description
        }
        
        if let language = jsonResult["language"] as? String {
            self.language = language
        }
    }
    
    // Actually fetch the list of repositories from the GitHub API.
    // Calls successCallback(...) if the request is successful
    class func fetchRepos(_ settings: GitHubSearchSettings, successCallback: @escaping ([GitHubModel]) -> (), error: ((Error?) -> ())?) {
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings()
        
        manager.get(reposUrl, parameters: params, success: { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
            if let response = responseObject as? NSDictionary, let results = response["items"] as? NSArray {
                var repos: [GitHubModel] = []
                for result in results as! [NSDictionary] {
                    repos.append(GitHubModel(jsonResult: result))
                }
                successCallback(repos)
            }
        }) { (operation: AFHTTPRequestOperation?, requestError: Error?) in
            if let errorCallback = error {
                errorCallback(requestError)
            }
        }
    }
    
    // Helper method that constructs a dictionary of the query parameters used in the request to the
    // GitHub API
    fileprivate class func queryParamsWithSettings() -> [String: String] {
        let settings = GitHubSearchSettings.sharedInstance
        var params: [String:String] = [:]
        if let clientId = clientId {
            params["client_id"] = clientId
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret
        }
        
        var q = ""
        if let searchString = settings.searchString {
            q = q + searchString
        }
        q = q + " stars:>\(settings.minStars)"
        
        if settings.language != "" {
            q = q + " language:\(settings.language?.lowercased())"
        }
        
        params["q"] = q
        
        params["sort"] = "stars"
        params["order"] = "desc"
        
        return params
    }
    
    // Creates a text representation of a GitHub repo
    var description: String {
        return "[Name: \(self.name)]" +
            "\n\t[Stars: \(self.stars)]" +
            "\n\t[Forks: \(self.forks)]" +
            "\n\t[Owner: \(self.ownerHandle)]" +
            "\n\t[Avatar: \(self.ownerAvatarURL)]" +
        "\n\t[Desc: \(self.repoDescription)]"
    }
}
