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

class IsotopeStorageManager {
    
    let persistentContainer: NSPersistentContainer!
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func fetchAllIsotopes() -> [IsotopeData] {
        let request: NSFetchRequest<IsotopeData> = IsotopeData.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [IsotopeData]()
    }
    
    func remove( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
    
    func insertIsotope(isotope: Isotope) -> IsotopeData? {
        guard let isotopeData = NSEntityDescription.insertNewObject(forEntityName: "IsotopeData", into: backgroundContext) as? IsotopeData else {return nil}
        isotopeData.atomName = isotope.atomName
        isotopeData.atomSymbol = isotope.atomSymbol
        isotopeData.halfLifeSec = isotope.halfLife
        return isotopeData
    }
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    func populateIsotopes(jsonUrl: URL) -> [IsotopeData] {
        var isotopes = [IsotopeData]()
        var json: [String: Any]?
        do {
            let jsonData = try Data(contentsOf: jsonUrl, options: .mappedIfSafe)
            json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        }
        catch {
            print(error)
        }
        if let json = json {
            for key in json.keys {
                if let atom = json[key] as? [String: Any] {
                    let atomName = atom["Atom Name"] as? String ?? ""
                    let atomSymbol = atom["Atom Symbol"] as? String ?? ""
                    let halfLifeSec = atom["Half-Life (s)"] as? Double ?? 0
                    let massNumber = atom["Mass Number"] as? Int ?? 0
                    let isotope = Isotope(atomName: atomName, atomSymbol: atomSymbol, halfLife: halfLifeSec, massNumber: massNumber)
                    let isotopeData = insertIsotope(isotope: isotope)
                    if isotopeData != nil {
                        isotopes.append(isotopeData!)
                    }   
                }
            }
        }
        
        return isotopes
    }
}
