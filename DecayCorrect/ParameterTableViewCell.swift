//
//  ParameterTableViewCell.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-03-04.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit


class ParameterTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        parameterLabel.textColor =  UIColor.black
        parameterValueTextField.textColor =  UIColor.black
        unitsLabel.textColor = UIColor.black
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var parameterLabel: UILabel!
    
    @IBOutlet weak var parameterValueTextField: UITextField!

    @IBOutlet weak var unitsLabel: UILabel!
    

}
