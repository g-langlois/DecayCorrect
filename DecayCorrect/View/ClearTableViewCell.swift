//
//  ClearTableViewCell.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-18.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class ClearTableViewCell: UITableViewCell {

    var clearButtonDelegate:ClearTableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clear(_ sender: UIButton) {
        if clearButtonDelegate != nil {
            clearButtonDelegate!.clearTable()
        }
    }
}


protocol ClearTableDelegate {
    func clearTable()
}
