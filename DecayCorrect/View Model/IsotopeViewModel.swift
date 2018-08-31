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
    
    
    init(_ isotope: Isotope? = nil) {
        sut = IsotopeStorageManager()
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
    
    func header(section: Int) -> String {
        switch section {
        case 0:
            if let atomName =  isotope?.atomName, let massNumber = isotope?.massNumber {
                return "\(atomName)-\(String(massNumber))"
            } else {
                return "New isotope"
            }
        case 1:
            return "Half-life units"
        default:
            return ""
        }
    }
    func titleForParameter(_ parameter: IsotopeParameter) -> String {
        switch parameter {
        case .halfLife:
            return "\(parameter.rawValue) (\(unitsSelection.rawValue))"
        default:
            return parameter.rawValue
        }
        
    }
    
    func valueForParameter(_ parameter: IsotopeParameter) -> String {
        switch parameter {
        case .atomName:
            return isotope?.atomName ?? ""
        case .massNumber:
            return String(isotope?.massNumber ?? 0)
        case .halfLife:
            return String(isotope?.halfLifeSec ?? 0)
        case .state:
            return isotope?.state ?? ""
        case .atomSymbol:
            return isotope?.atomSymbol ?? ""
            
        default:
            return ""
        }
    }
    
    func saveValueForParameter(_ parameter: IsotopeParameter, value: String) {
        switch parameter {
            
        // TODO exception handling
        case .atomName:
            isotope?.atomName = value
        case .massNumber:
            if let massNumber = Int32(value) {
                isotope?.massNumber = massNumber
            }
        case .halfLife:
            if let halfLife = Double(value) {
                isotope?.halfLifeSec = halfLife
            }
        case .state:
            // TODO verify it is only 1 char
            isotope?.state = value
        case .atomSymbol:
            isotope?.atomSymbol = value
        default:
            break
        }
        sut.save()
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
    
    var unitsSelection = IsotopeParameter.secSelection
    
    func isCheckmarkSelected(_ parameter: IsotopeParameter) -> Bool {
        if unitsSelection == parameter {
            return true
        } else {
            return false
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
    case atomSymbol = "Symbol"
}


