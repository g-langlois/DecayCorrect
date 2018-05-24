//
//  DataAccess.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-23.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataAccess {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

}
