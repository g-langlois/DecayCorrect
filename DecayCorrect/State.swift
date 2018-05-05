//
//  State.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-03.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation
class State {
    
    let defaults = UserDefaults.standard
    var isotopes = [Isotope]()
    var selectedIsotopeIndex: Int? {
        willSet {
            defaults.set(newValue, forKey: "isotopeIndex")
        }
    }
    init() {
        isotopes.append(Isotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18))
        isotopes.append(Isotope(atomName: "Gallium", atomSymbol: "Ga", halfLife: TimeInterval(68*60), massNumber: 68))
        selectedIsotopeIndex = defaults.integer(forKey: "isotopeIndex") 

    }
}
