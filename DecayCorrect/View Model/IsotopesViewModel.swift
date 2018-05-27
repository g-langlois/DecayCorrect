//
//  IsotopesViewModel.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-25.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

class IsotopesViewModel {
    
    var isotopes: [Isotope]?
    
    let defaults = UserDefaults.standard
    
    var selectedIsotopeId: UUID? {
        willSet {
            defaults.set(newValue?.uuidString, forKey: "selectedIsotopeId")
        }
    }
    
    init() {
        selectedIsotopeId = UUID(uuidString: (defaults.value(forKey: "selectedIsotopeId") as? String) ?? "")
        print("View loaded \(selectedIsotopeId)")
    }
    
    
}
