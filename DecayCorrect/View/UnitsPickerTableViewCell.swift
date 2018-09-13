//
//  UnitsTableViewCell.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-04-20.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class UnitsPickerTableViewCell: UITableViewCell {

    var delegate: UIPickerViewDelegate?
    var dataSource: UIPickerViewDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet weak var unitsPicker: UIPickerView!
    
}
