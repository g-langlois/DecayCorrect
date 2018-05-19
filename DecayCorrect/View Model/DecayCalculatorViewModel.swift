//
//  DecayCalculatorViewModel.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-11.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import Foundation

class DecayCalculatorViewModel: DecayCalculatorDelegate {
    
    let calculator = DecayCalculator()
    
    let isotopeViewModel: DecayTableViewItem
    let activity0ViewModel: DecayTableViewItem
    let activity1ViewModel: DecayTableViewItem
    let date1ViewModel: DecayTableViewItem
    let date0ViewModel: DecayTableViewItem
    
    
    var delegate: DecayCalculatorViewModelDelegate?
    
        let defaults = UserDefaults.standard
    var selectedIsotopeIndex: Int? {
        willSet {
            defaults.set(newValue, forKey: "isotopeIndex")
        }
    }
    
    init() {
        
        selectedIsotopeIndex = defaults.integer(forKey: "isotopeIndex")
        
        isotopeViewModel = DecayTableViewItem(source: .isotope, cellType: .isotopeView)
        activity0ViewModel = DecayTableViewItem(source: .activity0, cellType: .activityView)
        activity1ViewModel = DecayTableViewItem(source: .activity1, cellType: .activityView)
        date0ViewModel = DecayTableViewItem(source: .date0, cellType: .dateView)
        date1ViewModel = DecayTableViewItem(source: .date1, cellType: .dateView)
        calculator.delegate = self
    }
    
    func tagForSource(_ source: DecayCalculatorInput) -> Int {
        var tag: Int = 0
        switch source {
        case .activity0:
            tag = activity0ViewModel.source.tag
        case .activity1:
            tag = activity1ViewModel.source.tag
        case .date0:
            tag = date0ViewModel.source.tag
        case .date1:
            tag = date1ViewModel.source.tag
        default:
            break
            
        }
        return tag
    }
    
    func formatedDateForSource(_ source: DecayCalculatorInput) -> String {
        var date: Date?
        date = dateForSource(source)
        if date != nil {
            return formatDate(date!)
        } else {
        return ""
        }
    }
    
    func dateForSource(_ source: DecayCalculatorInput) -> Date? {
        var date: Date?
        switch source {
        case .date0:
            date = calculator.dateTime0
        case .date1:
            date = calculator.dateTime1
        default:
            date = nil
            
        }
        return date
    }
    
    func setDate(_ date: Date, forSource source: DecayCalculatorInput) {
        switch source {
        case .date0:
            calculator.dateTime0 = date
        case .date1:
            calculator.dateTime1 = date
        default:
            break
            
        }
        
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: date)
    }
    
    func formatedActivity(forSource source: DecayCalculatorInput) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 0
        let activity: Double?
        switch source {
        case .activity0:
            activity = calculator.activity0
        case .activity1:
            activity = calculator.activity1
        default:
            activity = nil
        }
        return formatter.string(for: activity)
    }
    
    func formatedUnits(forSource source: DecayCalculatorInput) -> String {
        let activityUnits: RadioactivityUnit?
        switch source {
        case .activity0:
            activityUnits = calculator.activity0Units
        case .activity1:
            activityUnits = calculator.activity1Units
        default:
            activityUnits = nil
        }
        return activityUnits?.rawValue ?? ""
    }
    
    func decayCalculatorDataChanged() {
        if let delegate = self.delegate {
            delegate.decayCalculatorViewModelChanged()
        }
    }
    
    func resetModel() {
        calculator.activity0 = nil
        calculator.activity0Units = nil
        calculator.activity1 = nil
        calculator.activity1Units = nil
        calculator.dateTime0 = nil
        calculator.dateTime1 = nil
    }
    
}


protocol DecayCalculatorViewModelDelegate {
    func decayCalculatorViewModelChanged()
}
