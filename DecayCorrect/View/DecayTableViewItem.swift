//
//  DecayTableViewItem.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-05.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

enum ParameterType {
    case activity0
    case activity1
    case date0
    case date1
}

enum PickerType {
    case date
    case unit
}

protocol DecayTableViewItem {
    var delegate: DecayCalculator? {get set}
    var parameterType: ParameterType  {get set}
    
    
}
