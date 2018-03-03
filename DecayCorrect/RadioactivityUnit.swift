//
//  RadioactivityUnit.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

enum RadioactivityUnit: String {
    case mbq = "MBq"
    case gbq = "GBq"
    case bq = "bq"
    case uci = "µCi"
    case mci = "mCi"
    case ci = "Ci"
    
    private func conversionFactorToBequerel(_ startingUnit: RadioactivityUnit) -> Double {
        switch(startingUnit) {
        case .bq:
            return 1
        case .mbq:
            return 1000000
        case .gbq:
            return 1000000000
        case .mci:
            return 37000000
        case .uci:
            return 37000
        case .ci:
            return 37000000000
        }
    }
    
    func conversionFactor(to finalUnit: RadioactivityUnit) -> Double {
        let startingUnitToBequerel = conversionFactorToBequerel(self)
        let finalUnitToBequerel = conversionFactorToBequerel(finalUnit)
        return startingUnitToBequerel / finalUnitToBequerel
    }
    
}

