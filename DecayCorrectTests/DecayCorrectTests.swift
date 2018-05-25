//
//  DecayCorrectTests.swift
//  DecayCorrectTests
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import XCTest
import CoreData
@testable import DecayCorrect

class DecayCorrectTests: XCTestCase {
    
    
    var sut: IsotopeStorageManager!

    override func setUp() {
        super.setUp()
        initStubs()
        sut = IsotopeStorageManager(container: mockPersistantContainer)
        
    }
    
    override func tearDown() {
        flushData()
        super.tearDown()
    }
    
    func testUnitsConversionFactors() {

        let accuracy = 0.00000001
        
        XCTAssertEqual(RadioactivityUnit.bq.conversionFactor(to: .bq), 1, accuracy: accuracy)
        XCTAssertEqual(RadioactivityUnit.gbq.conversionFactor(to: .gbq), 1, accuracy: accuracy)
        
        XCTAssertEqual(RadioactivityUnit.gbq.conversionFactor(to: .bq), 1000000000, accuracy: accuracy)
        XCTAssertEqual(RadioactivityUnit.bq.conversionFactor(to: .gbq), 1/1000000000, accuracy: accuracy)
        XCTAssertEqual(RadioactivityUnit.mbq.conversionFactor(to: .mci), 1/37, accuracy: accuracy)
    }
    
    func testDecayPrediction() {
        
        let accuracy = 0.00000001
        let isotope1 = Isotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(calendar: calendar, year: 2018, month: 01, day: 01, hour: 0, minute: 0))
        let initialRadioactivity = Radioactivity(time: date!, countRate: 1000, units: RadioactivityUnit.bq)
        let activity1 = RadioactiveSubstance(isotope: isotope1, radioactivity: initialRadioactivity)
        let predictedActivity = activity1.correct(to: calendar.date(from: DateComponents(calendar: calendar, year: 2018, month: 01, day: 01, hour: 0, minute: 110))!, with: RadioactivityUnit.bq)
        guard let countRate = predictedActivity?.countRate else {
            XCTFail()
            return
        }
        XCTAssertEqual(countRate, 500, accuracy: accuracy)
        
        
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DecayCorrect", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    
    func initStubs() {
        func insertIsotopeData(atomName: String, atomSymbol: String, halfLife: TimeInterval) -> IsotopeData? {
            let isotopeData = NSEntityDescription.insertNewObject(forEntityName: "IsotopeData", into: mockPersistantContainer.viewContext)
            isotopeData.setValue(atomName, forKey: "atomName")
            isotopeData.setValue(atomSymbol, forKey: "atomSymbol")
            isotopeData.setValue(halfLife, forKey: "halfLifeSec")
            return isotopeData as? IsotopeData
        }
        _ = insertIsotopeData(atomName: "Atom1", atomSymbol: "A1", halfLife: TimeInterval(1))
        _ = insertIsotopeData(atomName: "Atom2", atomSymbol: "A2", halfLife: TimeInterval(2))
        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func flushData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "IsotopeData")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
        
    }
    
    
    func  testCreateIsotopeData() {
        // Given
        let isotope1 = Isotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
       
        //When
        let isotopeData = sut.insertIsotope(isotope: isotope1)
        
        // Assert
        XCTAssertNotNil(isotopeData)
    }
    
    func testFetchAllIsotopesData() {
        let results = sut.fetchAllIsotopes()
        
        XCTAssertEqual(results.count, 2)
    }
    
    func testRemoveIsotope() {
        // Given an isotope in the library
        let items = sut.fetchAllIsotopes()
        let item = items[0]
        
        let numberOfItems = items.count
        
        //When removing the isotope
        sut.remove(objectID: item.objectID)
        sut.save()
        
        //Assert
        XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfItems - 1)
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "IsotopeData")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
    
    func testSave() {
        // Given
        let isotope1 = Isotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
    
        _ = sut.insertIsotope(isotope: isotope1)
        
        expectation(forNotification:NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue), object: nil)
        
        sut.save()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
