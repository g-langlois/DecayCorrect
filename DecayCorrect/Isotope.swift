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
    var atomName: String
    var atomSymbol: String
    var massNumber: Int
    
    init(atomName: String, atomSymbol: String, halfLife: TimeInterval, massNumber: Int) {
        self.halfLife = halfLife
        self.atomName = atomName
        self.atomSymbol = atomSymbol
        self.massNumber = massNumber
    }
    
    var shortName: String {
        get {
            return String("\(atomSymbol)\(massNumber)")
        }
    }
    
}
