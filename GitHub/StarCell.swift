//
//  StarCell.swift
//  GitHub
//
//  Created by Đoàn Minh Hoàng on 11/30/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

protocol StarCellDelegate {
    func starCell(didSlide value: Int)
}

class StarCell: UITableViewCell {

    @IBOutlet weak var sliderValueLabel: UILabel!
    var delegate: StarCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        delegate?.starCell(didSlide: Int(sender.value))
        sliderValueLabel.text = "\(Int(sender.value))"
    }
}
