//
//  DecayCalculatorViewModel.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-11.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

class DecayCalculatorViewModel: DecayCalculatorDelegate {
    
    let calculator = DecayCalculator()
    
    var delegate: DecayCalculatorViewModelDelegate?
    
        let defaults = UserDefaults.standard
    var selectedIsotopeIndex: Int? {
        willSet {
            defaults.set(newValue, forKey: "isotopeIndex")
        }
    }
    
    init() {
        calculator.delegate = self
        selectedIsotopeIndex = defaults.integer(forKey: "isotopeIndex")
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: date)
    }

    func decayCalculatorDataChanged() {
        if let delegate = self.delegate {
            delegate.decayCalculatorViewModelChanged()
        }
    }
    
}


protocol DecayCalculatorViewModelDelegate {
    func decayCalculatorViewModelChanged()
}
