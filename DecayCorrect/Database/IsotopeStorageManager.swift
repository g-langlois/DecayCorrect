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
    
    func fetchAllIsotopes() -> [Isotope] {
        let request: NSFetchRequest<Isotope> = Isotope.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Isotope]()
    }
    
    func remove( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
    

    func insertIsotope(atomName: String, atomSymbol: String, halfLife: TimeInterval, massNumber: Int, state: String?=nil) -> Isotope? {
        guard let isotope = NSEntityDescription.insertNewObject(forEntityName: "Isotope", into: backgroundContext) as? Isotope else {return nil}
        isotope.atomName = atomName
        isotope.atomSymbol = atomSymbol
        isotope.halfLifeSec = halfLife
        return isotope
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
    
    func populateIsotopes(jsonUrl: URL) -> [Isotope] {
        var isotopes = [Isotope]()
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
                    let isotope = insertIsotope(atomName: atomName, atomSymbol: atomSymbol, halfLife: halfLifeSec, massNumber: massNumber)
                    if isotope != nil {
                        isotopes.append(isotope!)
                    }   
                }
            }
        }
        
        return isotopes
    }
}
