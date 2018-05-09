//
//  UnitsViewModel.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-05.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class UnitsViewModel: NSObject, DecayTableViewItem, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerData = [RadioactivityUnit]()
    var delegate: DecayCalculator?
    var parameterType: ParameterType
    
    init(parameterType: ParameterType) {
        self.parameterType = parameterType
        self.delegate = nil
        pickerData.append(.bq)
        pickerData.append(.mbq)
        pickerData.append(.gbq)
        pickerData.append(.uci)
        pickerData.append(.mci)
        pickerData.append(.ci)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch parameterType {
        case .activity0:
            delegate?.activity0Units = pickerData[row]
        case .activity1:
            delegate?.activity1Units = pickerData[row]
        default: return
        }
        if delegate != nil {
            delegate!.updateResult()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
}
