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
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(ParameterTableViewCell.endEditing(_:)))
        
        toolbarDone.items = [barBtnDone]
        parameterValueTextField.inputAccessoryView = toolbarDone
    }


    @IBOutlet weak var parameterLabel: UILabel!
    
    @IBOutlet weak var parameterValueTextField: UITextField!

    @IBOutlet weak var unitsLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = self.unitsLabel.backgroundColor
        super.setSelected(selected, animated: animated)
        self.unitsLabel.backgroundColor = color
    }
}
