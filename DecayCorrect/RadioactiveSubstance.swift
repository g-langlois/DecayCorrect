//
//  Radioactivity.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

struct RadioactiveSubstance {
    
    let isotope: Isotope
    let originalRadioactivity: Radioactivity
    
    init(isotope: Isotope, radioactivity: Radioactivity) {
        self.isotope = isotope
        self.originalRadioactivity = radioactivity
    
        
    }
    
    func correct(to targetDate: Date) -> Radioactivity? {
        let correctedCountRate: Double
        let halfLife = isotope.halfLife
        let originalDate = originalRadioactivity.time
        let duration: TimeInterval
        if originalDate < targetDate {
            duration = DateInterval(start: originalDate, end: targetDate).duration
        }
        else {
            duration = -DateInterval(start: targetDate, end: originalDate).duration
        }
        
        //TODO
        /* t1/2 = ln2*t/ln(A0/At)
         At = A0/e^ln2*t/(t1/2)
        */
        correctedCountRate = originalRadioactivity.countRate /  (exp(log(2)*duration/halfLife))
        return Radioactivity(time: targetDate, countRate: correctedCountRate, units: .bq)
    }
}
