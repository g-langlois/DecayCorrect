//
//  Isotope.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

struct Isotope {
    var halfLife: TimeInterval
    
    init(atomName: String, atomSymbol: String, halfLife: TimeInterval, massNumber: Int) {
        self.halfLife = halfLife
        //TODO
    }
    
}
