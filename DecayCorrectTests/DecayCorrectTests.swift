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
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Isotope", into: mockPersistantContainer.viewContext)
        entity.setValue("Fluoride", forKey: "atomName")
        entity.setValue("F", forKey: "atomSymbol")
        entity.setValue(TimeInterval(110*60), forKey: "halfLifeSec")
        let isotope = entity as! Isotope
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(calendar: calendar, year: 2018, month: 01, day: 01, hour: 0, minute: 0))
        let initialRadioactivity = Radioactivity(time: date!, countRate: 1000, units: RadioactivityUnit.bq)
        let activity1 = RadioactiveSubstance(isotope: isotope, radioactivity: initialRadioactivity)
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
        func insertIsotopeData(atomName: String, atomSymbol: String, halfLife: TimeInterval) -> Isotope? {
            let isotope = NSEntityDescription.insertNewObject(forEntityName: "Isotope", into: mockPersistantContainer.viewContext)
            isotope.setValue(atomName, forKey: "atomName")
            isotope.setValue(atomSymbol, forKey: "atomSymbol")
            isotope.setValue(halfLife, forKey: "halfLifeSec")
            return isotope as? Isotope
        }
        _ = insertIsotopeData(atomName: "Fluoride18", atomSymbol: "F18", halfLife: TimeInterval(110*60))
        _ = insertIsotopeData(atomName: "Atom1", atomSymbol: "A1", halfLife: TimeInterval(1))
        _ = insertIsotopeData(atomName: "Atom2", atomSymbol: "A2", halfLife: TimeInterval(2))
        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func flushData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Isotope")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
        
    }
    
    
    func  testCreateIsotopeData() {
        // Given
        let atomName = "Fluoride"
        let atomSymbol = "F"
        let halfLife = 2.0
        let massNumber = 18
    
        
        //When
        let isotope = sut.insertIsotope(atomName: atomName, atomSymbol: atomSymbol, halfLife: halfLife, massNumber: massNumber)
        
        // Assert
        XCTAssertNotNil(isotope)
    }
    
    func testFetchAllIsotopesData() {
        let results = sut.fetchAllIsotopes()
        
        XCTAssertEqual(results.count, 3)
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
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Isotope")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
    
    func testSave() {
        
    
        _ = sut.insertIsotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
        
        expectation(forNotification:NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue), object: nil)
        
        sut.save()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadJsonFile() {
        let testBundle = Bundle(for: type(of: self))
        guard let jsonPath = testBundle.url(forResource: "isotopesTest", withExtension: "json") else {
            XCTFail()
            return
        }
        
        let isotopesData = sut.populateIsotopes(jsonUrl: jsonPath)
    
        XCTAssertEqual(isotopesData.count, 2)
    }
    
    func testRetreiveIsotopeFromJson() {
        //Given
        let testBundle = Bundle(for: type(of: self))
        guard let jsonPath = testBundle.url(forResource: "isotopesTest", withExtension: "json") else {
            XCTFail()
            return
        }
        
        //When
        let isotopes = sut.populateIsotopes(jsonUrl: jsonPath)
        
        
        
        //Then
        XCTAssertEqual(isotopes[0].atomName!, "Atom Name 1")
        XCTAssertEqual(isotopes[0].atomSymbol!, "A")
        XCTAssertEqual(isotopes[0].halfLifeSec, 1.0)
        XCTAssertEqual(isotopes[0].massNumber, Int32(1))
    }
    
    func testSplitMassStateString() {
        let massState = "123m"
        
        let massStateSplitted = sut.splitMassState(from: massState)
        
        XCTAssert(massStateSplitted.massNumber == 123)
        XCTAssert(massStateSplitted.state == "m")
    }
    
    func testFetchIsotopeFromUniqueId() {
        //Given
        let isotope = sut.insertIsotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
        sut.save()
        let uniqueId = isotope?.uniqueId
        
        // When
        let fetchedIsotope = sut.fetchIsotope(with: uniqueId!)
        
        //Then
        XCTAssertNotNil(fetchedIsotope)
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
