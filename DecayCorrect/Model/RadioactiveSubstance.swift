//
//  Radioactivity.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

struct RadioactiveSubstance {
    
    let isotope: Isotope?
    let originalRadioactivity: Radioactivity
    
    init(isotope: Isotope, radioactivity: Radioactivity) {
        self.isotope = isotope
        self.originalRadioactivity = radioactivity
    }
    
    
    
    func correct(to targetDate: Date, with targetUnits: RadioactivityUnit?) -> Radioactivity? {
        guard let isotope = isotope, let originalUnits = self.originalRadioactivity.units else {
            return nil
        }
        let correctedCountRate: Double
        let halfLife = isotope.halfLifeSec
        let originalDate = originalRadioactivity.time
        let duration: TimeInterval
        if originalDate < targetDate {
            duration = DateInterval(start: originalDate, end: targetDate).duration
        }
        else {
            duration = -DateInterval(start: targetDate, end: originalDate).duration
        }
        var units = targetUnits
        if units == nil {
            units = self.originalRadioactivity.units
        }
        
        let conversionFactor = originalUnits.conversionFactor(to: units!)

        correctedCountRate = conversionFactor * originalRadioactivity.countRate /  (exp(log(2)*duration/halfLife))
        return Radioactivity(time: targetDate, countRate: correctedCountRate, units: units)
    }
}
