//
//  GitHubViewController.swift
//  GitHub
//
//  Created by Đoàn Minh Hoàng on 11/25/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class GitHubViewController: UIViewController {
    var searchBar: UISearchBar!
    var searchSettings = GitHubSearchSettings()
    let refreshControl = UIRefreshControl()
    
    var repos: [GitHubModel]!
    @IBOutlet weak var gitHubTableView: UITableView!
    
    let languageArray = ["Java", "JavaScript", "Objective-C", "Pythorn", "Ruby", "Swift"]
    var isLanguageChecked = [true, true, true, true, true, true]
    var starArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Add Pull to Refresh
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        gitHubTableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        GitHubModel.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in
            // Load data
            self.repos = newRepos
            self.starArray.removeAll()
            for star in self.repos {
                self.starArray.append(star.stars)
            }
            self.gitHubTableView.reloadData()
            refreshControl.endRefreshing()
        }, error: { (error) -> Void in
            print(error!)
            refreshControl.endRefreshing()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Perform the first search when the view controller first loads
        doSearch()
    }
    
    // Perform the search.
    fileprivate func doSearch() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // Perform request to GitHub API to get the list of repositories
        GitHubModel.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in
            // Load data
            self.repos = newRepos
            self.starArray.removeAll()
            for star in self.repos {
                self.starArray.append(star.stars)
            }
            self.gitHubTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }, error: { (error) -> Void in
            print(error!)
        })
    }
    
    // Send default search data to settings screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displaySettings" {
            let settingsViewController = segue.destination as! GitHubSettingsViewController
            settingsViewController.languageArray = self.languageArray
            settingsViewController.isLanguageChecked = self.isLanguageChecked
            settingsViewController.minStar = self.starArray.min()
            settingsViewController.maxStar = self.starArray.max()
            settingsViewController.delegate = self
        }
    }
}

extension GitHubViewController: GitHubSettingsDelegate {
    func gitHubSettings(didUpdateSettings searchSettings: GitHubSearchSettings, languageChecked: [Bool]) {
        self.searchSettings = searchSettings
        self.isLanguageChecked = languageChecked
    }
}

// SearchBar
extension GitHubViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}

// TableView
extension GitHubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GitHubTableViewCell") as! GitHubTableViewCell
        cell.labelName.text = self.repos[indexPath.row].name
        cell.labelStar.text = String(self.repos[indexPath.row].stars)
        cell.labelFork.text = String(self.repos[indexPath.row].forks)
        cell.labelOwner.text = self.repos[indexPath.row].ownerHandle
        cell.imageAvatar.setImageWith(URL(string: self.repos[indexPath.row].ownerAvatarURL)!)
        cell.labelDescription.text = self.repos[indexPath.row].repoDescription
        return cell
    }
}

// TableViewCell
class GitHubTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStar: UILabel!
    @IBOutlet weak var labelFork: UILabel!
    @IBOutlet weak var labelOwner: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
}
