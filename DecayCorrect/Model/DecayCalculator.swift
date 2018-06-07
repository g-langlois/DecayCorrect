//
//  State.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-03.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class DecayCalculator {
    
    let defaults = UserDefaults.standard
    let sut = IsotopeStorageManager()
    
    var isotope: Isotope? {
        get {
            let selectedIsotopeId = UUID(uuidString: (defaults.value(forKey: "selectedIsotopeId") as? String) ?? "")
            if selectedIsotopeId != nil {
                return sut.fetchIsotope(with: selectedIsotopeId!)
            } else {
                return nil
            }
            
        }
    }
    
    var activity0: Double?
    var dateTime0: Date?
    var activity0Units: RadioactivityUnit?
    var activity1: Double?
    var dateTime1: Date?
    var activity1Units: RadioactivityUnit?
    var targetParameter: DecayCalculatorInput?
    var defaultUnits = RadioactivityUnit.mbq

    var delegate: DecayCalculatorDelegate?
    
    
    
    init() {
        
    }
    
    func updateResult() {
        findTargetParameter()
        guard let targetParameter = self.targetParameter else {
            if let delegate = self.delegate {
                delegate.decayCalculatorDataChanged()
                
            }
            return
            
        }
        guard let isotope1 = isotope else {
            return
        }
        
        if targetParameter == .activity1, let activity0 = activity0, let dateTime0 = dateTime0, let dateTime1 = dateTime1 {
            if activity0Units == nil {
                activity0Units = defaultUnits
            }
            let initialRadioactivity = Radioactivity(time: dateTime0, countRate: activity0, units: activity0Units)
            let radioactiveSubstance = RadioactiveSubstance(isotope: isotope1, radioactivity: initialRadioactivity)
            let activity = radioactiveSubstance.correct(to: dateTime1, with: activity1Units)
            activity1 = activity?.countRate
            activity1Units = activity?.units
        }
        if let delegate = self.delegate {
            delegate.decayCalculatorDataChanged()
            
        }
    }
    
    func findTargetParameter(){
        
        var parameterType: DecayCalculatorInput?
        var count = 0
        // Verifies that exactly 1 parameter is missing
        if activity0 == nil {
            count += 1
            parameterType = .activity0
        }
        if activity1 == nil {
            count += 1
            parameterType = .activity1
        }
        if dateTime0 == nil {
            count += 1
            parameterType = .date0
        }
        if dateTime1 == nil {
            count += 1
            parameterType = .date1
        }
        if count == 1 {
            self.targetParameter = parameterType
        }
    }
}

enum DecayCalculatorInput: Int {
    case activity0 = 1000
    case activity1 = 1001
    case date0 = 10000
    case date1 = 10001
    case isotope = 0
    
    
    var tag: Int {
       return self.rawValue
    }
    
    var id: Int {
        switch self {
        case .activity0, .date0:
            return 0
        case .activity1, .date1:
            return 1

        default:
        return 0
        }
    }
    
}

protocol DecayCalculatorDelegate {
    func decayCalculatorDataChanged()
}


