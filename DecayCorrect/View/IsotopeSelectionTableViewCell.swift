//
//  IsotopeSelectionTableViewCell.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-02.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class IsotopeSelectionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet weak var isotopeId: UILabel!

    @IBOutlet weak var isotopeName: UILabel!
}
