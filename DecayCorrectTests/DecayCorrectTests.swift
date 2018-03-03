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
    
    func testDecay() {
        
        let accuracy = 0.00000001
        let isotope1 = Isotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
        //let activity1 = RadioactiveSubstance(isotope1)
    }
    
    func testBackDecay() {
        
        let accuracy = 0.00000001
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
