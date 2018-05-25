//
//  IsotopeData+CoreDataProperties.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-23.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//
//

import Foundation
import CoreData


extension IsotopeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IsotopeData> {
        return NSFetchRequest<IsotopeData>(entityName: "IsotopeData")
    }

    @NSManaged public var atomName: String?
    @NSManaged public var atomSymbol: String?
    @NSManaged public var custom: Bool
    @NSManaged public var halfLifeSec: Double
    @NSManaged public var massNumber: Int32
    @NSManaged public var state: String?

}
