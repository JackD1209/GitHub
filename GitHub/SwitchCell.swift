//
//  SwitchCell.swift
//  GitHub
//
//  Created by Đoàn Minh Hoàng on 11/30/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate {
    func switchCell(didSwitch value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchToggle: UISwitch!
    var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func isSwitched(_ sender: UISwitch) {
        delegate?.switchCell(didSwitch: sender.isOn)
    }
}
