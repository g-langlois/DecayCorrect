//
//  Activity.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

struct Radioactivity {
    
    let time: Date
    let countRate: Double
    let units: RadioactivityUnit?
    
    init(time: Date, countRate: Double, units: RadioactivityUnit?) {
        self.time = time
        self.countRate = countRate
        self.units = units
    }
}
