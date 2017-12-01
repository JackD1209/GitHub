//
//  GitHubSearchSetting.swift
//  GitHub
//
//  Created by Đoàn Minh Hoàng on 11/25/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import Foundation

class GitHubSearchSettings {
    static let sharedInstance = GitHubSearchSettings()
    var searchString: String?
    var minStars = 0
    var language: String?
    
    init() {
        
    }
}
