//
//  IsotopeTableViewCell.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-06-09.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class IsotopeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var parameterTitleLabel: UILabel!
    
    @IBOutlet weak var parameterValueTextField: UITextField!
}
