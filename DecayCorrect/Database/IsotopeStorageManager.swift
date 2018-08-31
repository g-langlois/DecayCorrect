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
    
    let defaults = UserDefaults.standard
    let persistentContainer: NSPersistentContainer!


    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        initJson()
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get shared app delegate")
        }
        
        self.init(container: appDelegate.persistentContainer)
    }
    
    
    
    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    func initJson() {
        if !self.isJsonInitiated() {
            let url = Bundle.main.url(forResource: "nuclides", withExtension: "json")
            _ = populateIsotopes(jsonUrl: url!)
            save()
        }
    }
    
    func fetchAllIsotopes() -> [Isotope] {
        let request: NSFetchRequest<Isotope> = Isotope.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Isotope.massNumber), ascending: true)
        request.sortDescriptors = [sort]
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Isotope]()
    }
    
    func remove( objectID: NSManagedObjectID ) {
        let obj = context.object(with: objectID)
        context.delete(obj)
    }
    

    func insertIsotope() -> Isotope? {
        guard let isotope = NSEntityDescription.insertNewObject(forEntityName: "Isotope", into: context) as? Isotope else {return nil}
        return isotope
    }
    
    func insertIsotope(atomName: String, atomSymbol: String, halfLife: TimeInterval, massNumber: Int, isCustom: Bool = false, state: String?=nil) -> Isotope? {
        guard let isotope = NSEntityDescription.insertNewObject(forEntityName: "Isotope", into: context) as? Isotope else {return nil}
        isotope.atomName = atomName
        isotope.atomSymbol = atomSymbol
        isotope.massNumber = Int32(massNumber)
        isotope.state = state
        isotope.halfLifeSec = halfLife
        isotope.custom = isCustom
        isotope.uniqueId = UUID()
        return isotope
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    func isJsonInitiated() -> Bool {
        return defaults.bool(forKey: "jsonInitiated")
         
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
                    let halfLifeSec = Double(atom["Half-Life (s)"] as? String ?? "") ?? 0
                    let massNumberState = atom["Mass Number"] as? String ?? ""
                    
                    let massStateSplit = splitMassState(from: massNumberState)
                    let massNumber = massStateSplit.massNumber
                    let state = massStateSplit.state
                    let isotope = insertIsotope(atomName: atomName, atomSymbol: atomSymbol, halfLife: halfLifeSec, massNumber: massNumber, state: state)
                    if isotope != nil {
                        isotopes.append(isotope!)
                    }   
                }
            }
            defaults.set(true, forKey: "jsonInitiated")
        }
        return isotopes
    }
    
    func fetchIsotope(with id: UUID) -> Isotope? {
        let requestIsotope: NSFetchRequest<Isotope> = Isotope.fetchRequest()
        
        let query = NSPredicate(format: "%K == %@", "uniqueId", id as CVarArg)
        
        requestIsotope.predicate = query
        
        do {
            let isotopes: [Isotope] = try context.fetch(requestIsotope)
            return isotopes[0]
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return nil
    }
    

    // Helpers
    
    func splitMassState(from string: String) -> (massNumber: Int, state: String?) {
        var massNumberString:String = ""
        var state: String?
        
        let digitSet = CharacterSet.decimalDigits
        
        for char in string.unicodeScalars {
            if digitSet.contains(char) {
                massNumberString.append(char.escaped(asASCII: true))
            } else {
                if state != nil {
                    state!.append(char.escaped(asASCII: true))
                } else {
                    state = char.escaped(asASCII: true)
                }
            }
            
        }
        let massNumber = Int(massNumberString) ?? 0

        return (massNumber, state)
        
    }
    
}
