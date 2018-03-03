//
//  DecayCorrectTests.swift
//  DecayCorrectTests
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import XCTest
@testable import DecayCorrect

class DecayCorrectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        let predictedActivity = activity1.correct(to: calendar.date(from: DateComponents(calendar: calendar, year: 2018, month: 01, day: 01, hour: 0, minute: 110))!)
        guard let countRate = predictedActivity?.countRate else {
            XCTFail()
            return
        }
        XCTAssertEqual(countRate, 500, accuracy: accuracy)
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
