//
//  Isotope+CoreDataProperties.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-25.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//
//

import Foundation
import CoreData


extension Isotope {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Isotope> {
        return NSFetchRequest<Isotope>(entityName: "Isotope")
    }

    @NSManaged public var atomName: String?
    @NSManaged public var atomSymbol: String?
    @NSManaged public var custom: Bool
    @NSManaged public var halfLifeSec: Double
    @NSManaged public var massNumber: Int32
    @NSManaged public var state: String?

}
