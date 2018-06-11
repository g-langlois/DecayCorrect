//
//  IsotopeParameterViewModel.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-06-09.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

class IsotopeViewModel {
    
    var isotope: Isotope?
    var sut: IsotopeStorageManager!
    
    
    init(_ isotope: Isotope?) {
        if isotope != nil {
        self.isotope = isotope
        } else {
            self.isotope = sut.insertIsotope()
        }
        
    }
    
    func saveIsotope() {
        if isotope != nil {
            sut.save()
        }
    }
    
    func header() -> String {
        if let atomName =  isotope?.atomName, let massNumber = isotope?.massNumber {
        return "\(atomName)-\(String(massNumber))"
        } else {
            return "New isotope"
        }
    }
    func titleForParameter(_ parameter: IsotopeParameter) -> String {
        return parameter.rawValue
    }
    
    func valueForParameter(_ parameter: IsotopeParameter) -> String {
        switch parameter {
        case .atomName:
            return isotope?.atomName ?? ""
        case .massNumber:
            return String(isotope?.massNumber ?? 0)
        case .halfLifeSec:
            return String(isotope?.halfLifeSec ?? 0)
        case .state:
            return isotope?.state ?? ""
        default:
            return ""
        }
    }
    
    func setValueForParameter(_ parameter: IsotopeParameter, value: String) {
        switch parameter {
        case .atomName:
            isotope?.atomName = value
        case .massNumber:
            isotope?.massNumber = Int32(value) ?? 0
        case .halfLifeSec:
            isotope?.halfLifeSec = Double(value) ?? 0
        case .state:
            isotope?.state = value
        default:
            break
        }
    }
    
    func isEditable(_ parameter: IsotopeParameter) -> Bool {
        switch parameter {
        case .halfLifeSec:
            return false
        default:
            return true
        }
    }
    
}

enum IsotopeParameter: String {
    case atomName = "Atom"
    case massNumber = "Mass number"
    case isFavorite = "Favorite"
    case custom = "Edited"
    case halfLifeSec = "Half life (sec)"
    case halfLife = "Half life"
    case secSelection = "Seconds"
    case minSelection = "Minutes"
    case hourSelection = "Hour"
    case daySelection = "Day"
    case yearSelection = "Year"
    case state = "Isomeric state"
}


