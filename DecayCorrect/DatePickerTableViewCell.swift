//
//  DatePickerTableViewCell.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-03-04.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {


    var delegate: DatePickerDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var datePicker: UIView!
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.dateValueChanged(newValue: sender.date)
     
    }
    
    
}

protocol DatePickerDelegate {
    func dateValueChanged(newValue: Date)
}
