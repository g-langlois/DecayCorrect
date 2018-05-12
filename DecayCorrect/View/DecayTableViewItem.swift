//
//  DecayTableViewItem.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-05.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

enum ParameterType: Int {
    case activity0 = 1000
    case activity1 = 1001
    case date0 = 10000
    case date1 = 10001
}

enum PickerType {
    case date
    case unit
}

protocol DecayTableViewItem {
    var delegate: DecayCalculatorViewModel? {get set}
    var parameterType: ParameterType  {get set}
    
    
}
