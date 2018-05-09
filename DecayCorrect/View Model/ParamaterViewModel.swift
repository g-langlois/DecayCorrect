//
//  ParamaterViewModel.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-05.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class ParameterViewModel: NSObject, DecayTableViewItem, UITextFieldDelegate {
    var delegate: DecayCalculator?
    var parameterType: ParameterType
    var decayViewController: DecayTableViewController?
    
    init(parameterType: ParameterType) {
        self.parameterType = parameterType
        self.delegate = nil
    }
    
    // Hides soft keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        decayViewController!.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard let activityValue = Double(textField.text!) else {
            return
            
        }
        switch parameterType {
        case .activity0:
            delegate?.activity0 = activityValue
        case .activity1:
            delegate?.activity1 = activityValue
        default: return
        }
        if delegate != nil {
            delegate!.updateResult()
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
    
    // Formatting
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: date)
    }
}
