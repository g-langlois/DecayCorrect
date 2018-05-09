//
//  DatePickerViewModel.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-05.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class DatePickerViewModel: NSObject, DecayTableViewItem, DatePickerDelegate {
    var delegate: DecayCalculator?
    var parameterType: ParameterType
    
    
    init(parameterType: ParameterType) {
        self.parameterType = parameterType
        self.delegate = nil
    }
    
    func dateValueChanged(newValue: Date) {
        switch parameterType {
        case .date0:
            delegate?.dateTime0 = newValue
        case .date1:
            delegate?.dateTime1 = newValue
        default: return
        }
        if delegate != nil {
            delegate!.updateResult()
        }
    }
    
}
