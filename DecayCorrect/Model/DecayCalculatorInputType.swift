//
//  DecayCalculatorInputType.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-09-10.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

enum DecayCalculatorInputType: Int {
    case activity0 = 1000
    case activity1 = 1001
    case date0 = 10000
    case date1 = 10001
    case isotope = 0
    
    
    // Tag used to differentiate content of UITableViewCells
    var tag: Int {
        return self.rawValue
    }
    
    // Numbering used to construct String (e.g.: "Activity A0")
    var numbering: Int {
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
