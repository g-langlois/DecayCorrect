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
    }
    
    var delegate: IsotopeTableViewCellDelegate? = nil

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var parameterTitleLabel: UILabel!
    
    @IBOutlet weak var parameterValueTextField: UITextField!
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        if delegate != nil {
            delegate!.editingDidEnd(sender.text!)
        }
    }
}

protocol IsotopeTableViewCellDelegate {
    func editingDidEnd(_ value: String)
}

