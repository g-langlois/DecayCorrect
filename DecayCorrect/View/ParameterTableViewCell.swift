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
