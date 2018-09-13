//
//  DatePickerTableViewCell.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-03-04.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    var delegate: DecayTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        delegate?.dateValueChanged(newValue: sender.date, forPickerWithTag: sender.tag)
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
}

protocol DatePickerDelegate {
    func dateValueChanged(newValue: Date, forPickerWithTag: Int)
    
}
