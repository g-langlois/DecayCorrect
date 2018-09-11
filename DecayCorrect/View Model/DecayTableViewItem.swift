//
//  DecayTableViewItem.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-05.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

enum CellType {
    case dateView
    case activityView
    case datePicker
    case unitPicker
    case isotopeView
}

struct DecayTableViewItem {
    var cellType: CellType
    var source: DecayCalculatorInputType
    
    init(source: DecayCalculatorInputType, cellType: CellType) {
        self.source = source
        self.cellType = cellType
    }
}
