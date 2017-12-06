//
//  GitHubSettingsViewController.swift
//  GitHub
//
//  Created by Đoàn Minh Hoàng on 11/29/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

protocol GitHubSettingsDelegate {
    func gitHubSettings(didUpdateSettings searchSettings: GitHubSearchSettings, languageChecked: [Bool])
}

class GitHubSettingsViewController: UIViewController {
    @IBOutlet weak var gitHubSettingsTableView: UITableView!
    
    var searchSettings = GitHubSearchSettings()
    let sectionArray = ["Stars", "Languages"]
    var languageArray: [String] = []
    var isLanguageChecked: [Bool] = []
    var minStar: Int?
    var maxStar: Int?
    var didLanguageSwitched = false
    var searchLanguage = ""
    var delegate: GitHubSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        for (index, language) in isLanguageChecked.enumerated() {
            if language {
                searchLanguage += languageArray[index] + " "
            }
        }
        self.searchSettings.language = searchLanguage
        delegate?.gitHubSettings(didUpdateSettings: self.searchSettings, languageChecked: self.isLanguageChecked)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GitHubSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return languageArray.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if didLanguageSwitched {
                return 75
            }
            else {
                return indexPath.row == 0 ? 75 : 0
            }
        default:
            return 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let starCell = tableView.dequeueReusableCell(withIdentifier: "StarCell") as! StarCell
            starCell.slider.minimumValue = Float(self.minStar!)
            starCell.slider.maximumValue = Float(self.maxStar!)
            starCell.delegate = self
            return starCell
        case 1:
            let swichCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            let tickCell = tableView.dequeueReusableCell(withIdentifier: "TickCell") as! TickCell
            swichCell.delegate = self
            if didLanguageSwitched {
                if indexPath.row == 0 {
                    swichCell.switchToggle.isOn = true
                    return swichCell
                } else {
                    tickCell.languageLabel.text = languageArray[indexPath.row - 1]
                    if isLanguageChecked[indexPath.row - 1] {
                        tickCell.languageImage.image = UIImage(named: "check")
                    } else {
                        tickCell.languageImage.image = UIImage(named: "uncheck")
                    }
                    return tickCell
                }
            } else {
                swichCell.switchToggle.isOn = false
                return swichCell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print()
        case 1:
            if indexPath.row != 0 {
                if isLanguageChecked[indexPath.row - 1] {
                    isLanguageChecked[indexPath.row - 1] = false
                } else {
                    isLanguageChecked[indexPath.row - 1] = true
                }
            }
        default:
            break
        }
        gitHubSettingsTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
    }
}

extension GitHubSettingsViewController: SwitchCellDelegate {
    func switchCell(didSwitch value: Bool) {
        didLanguageSwitched = value
        gitHubSettingsTableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
    }
}

extension GitHubSettingsViewController: StarCellDelegate {
    func starCell(didSlide value: Int) {
        searchSettings.minStars = value
    }
}
