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
        // Initialization code
    }

    var uiTextFieldDelegate: UITextFieldDelegate?

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var parameterLabel: UILabel!
    
    @IBOutlet weak var parameterValueTextField: UITextField!
//    @IBAction func textFieldEndEditing(_ sender: UITextField) {
//        if let delegate = self.uiTextFieldDelegate {
//            delegate.textFieldDidEndEditing!(parameterValueTextField)
//            
//            
//        }
//    }
}
