//
//  DecayTableViewController.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class DecayTableViewController: UITableViewController, DatePickerDelegate {
    
    // MARK: - Properties
    
    var resultAvailable = true
    var datePickerIndexPath:IndexPath?
    var datePickerDate: Date?
    
    let decayModel = DecayModel()

    var activity0: Double?
    var activity0Delegate = ParameterViewModel(parameterType: .activity0)
    var activity0IndexPath = IndexPath(row: 0, section: 1)
    
    
    var dateTime0: Date?
    var dateTime0Delegate = ParameterViewModel(parameterType: .date0)
    var dateTime0IndexPath = IndexPath(row: 1, section: 1)
    
    var activity1: Double?
    var activity1Delegate = ParameterViewModel(parameterType: .activity1)
    var activity1IndexPath = IndexPath(row: 2, section: 1)
    
    var dateTime1: Date? {
        didSet {
            calculate()
        }
    }
    var dateTime1Delegate = ParameterViewModel(parameterType: .date1)
    var dateTime1IndexPath = IndexPath(row: 0, section: 2)
    
    
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity0Delegate.delegate = self
        activity1Delegate.delegate = self
        dateTime1Delegate.delegate = self
        dateTime0Delegate.delegate = self
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if resultAvailable == true {
            return 3
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch section {
        case 0:
            numberOfRows = 2
        case 1:
            if resultAvailable == true && datePickerIndexPath == nil {
                numberOfRows = 3
            } else if !resultAvailable && datePickerIndexPath == nil {
                numberOfRows = 4
            } else if resultAvailable && datePickerIndexPath != nil && datePickerIndexPath!.section == 1 {
                numberOfRows = 4
            }
            else if resultAvailable && datePickerIndexPath != nil && datePickerIndexPath!.section != 1 {
                numberOfRows = 3
            }
            else {
                numberOfRows = 5
            }
        case 2:
            if datePickerIndexPath != nil && datePickerIndexPath!.section == 2 {
                numberOfRows = 2
            }
            else {
                numberOfRows = 1
            }
        default:
            break
            
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Parameters"
        case 1:
            return "Inputs (any three)"
        case 2:
            return "Result"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let datePickerIndexPath = datePickerIndexPath, indexPath == datePickerIndexPath{
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: "datePicker", for: indexPath) as! DatePickerTableViewCell
            datePickerCell.delegate = self
            return datePickerCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "parameter", for: indexPath) as! ParameterTableViewCell
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            cell.parameterLabel.text = "Isotope"
            cell.parameterValueTextField.placeholder = "Isotope"
            
        case IndexPath(row: 1, section: 0):
            cell.parameterLabel.text = "Units"
            cell.parameterValueTextField.placeholder = "Units"
            
        case dateTime0IndexPath:
            cell.parameterLabel.text = "Date (t0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.isEnabled = false
            cell.parameterValueTextField.placeholder = "Date"
            if let dateTime = dateTime0 {
                cell.parameterValueTextField.text = formatDate(dateTime)
            }
            
        case activity0IndexPath:
            cell.parameterLabel.text = "Activity (A0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Activity"
            cell.parameterValueTextField.delegate = activity0Delegate
            
            
        case dateTime1IndexPath:
            cell.parameterLabel.text = "Date (t1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Date"
            cell.parameterValueTextField.isEnabled = false
            if let dateTime = dateTime1 {
                cell.parameterValueTextField.text = formatDate(dateTime)
            }
            
        case activity1IndexPath:
            cell.parameterLabel.text = "Activity (A1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Activity"
            cell.parameterValueTextField.delegate = activity1Delegate
            cell.parameterValueTextField.text = String(describing: activity1)
            
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            hideDatePicker()
        case IndexPath(row: 1, section: 0):
            hideDatePicker()
        case correctIndexPathWithDatePicker(for: activity0IndexPath):
            hideDatePicker()
        case correctIndexPathWithDatePicker(for: dateTime0IndexPath):
            toggleDatePicker(for: indexPath)
            
            
        case correctIndexPathWithDatePicker(for: activity1IndexPath):
            hideDatePicker()
        case correctIndexPathWithDatePicker(for: dateTime1IndexPath):
            toggleDatePicker(for: indexPath)
            datePickerDate = dateTime1
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    // MARK: - Date Picker
    
    // DatePickerDelegate conformance.
    func dateValueChanged(newValue: Date) {
        guard let datePickerRow = datePickerIndexPath?.row else { return }
        if datePickerRow == dateTime0IndexPath.row + 1 {
            dateTime0 = newValue
        } else if datePickerRow == dateTime1IndexPath.row + 1 {
            dateTime1 = newValue
        }
        tableView.reloadData()
    }
    
    private func correctIndexPathWithDatePicker(for indexPath: IndexPath) -> IndexPath {
        var correctedIndexPath = indexPath
        if let datePickerIndexPath = datePickerIndexPath {
            if indexPath.section == datePickerIndexPath.section {
                if indexPath.row > datePickerIndexPath.section {
                    correctedIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                }
            }
        }
        return correctedIndexPath
    }
    
    private func toggleDatePicker(for indexPath: IndexPath) {
        tableView.beginUpdates()
        if (datePickerIndexPath != nil && datePickerIndexPath == indexPath) {
            return
        } else if (datePickerIndexPath != nil && datePickerIndexPath == IndexPath(row: indexPath.row + 1, section: indexPath.section)) {
            tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
            datePickerDate = nil
        } else if (datePickerIndexPath != nil) {
            tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
            datePickerDate = nil
        } else  {
            
            datePickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [datePickerIndexPath!], with: .fade)
        }
        // To get third section appear:
        //resultAvailable = true
        // let indexSet = IndexSet.init()
        //indexSet.insert(2)
        //tableView.insertSections(indexSet, with: .fade)
        //
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
    }
    
    private func hideDatePicker() {
        tableView.beginUpdates()
        if (datePickerIndexPath != nil) {
            tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
        }
        datePickerDate = nil
        
        tableView.endUpdates()
    }
    
    
    // UITextFieldDelegate 
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        //TODO
    }
    
    
    // MARK: - Data formating
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - Logic
    
    private func splitInputToResultSection() {
        //TODO
    }
    
    func calculate() {
        
        // TODO handle optionals
        let isotope1 = Isotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
    
        let initialRadioactivity = Radioactivity(time: dateTime0!, countRate: activity0!, units: RadioactivityUnit.bq)
        let radioactiveSubstance = RadioactiveSubstance(isotope: isotope1, radioactivity: initialRadioactivity)
        activity1 = radioactiveSubstance.correct(to: dateTime1!)?.countRate
        tableView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

enum ParameterType {
    case activity0
    case activity1
    case date0
    case date1
}


class ParameterViewModel: NSObject, UITextFieldDelegate, DatePickerDelegate {
    var delegate: DecayTableViewController?
    
    var parameterType: ParameterType
    init(parameterType: ParameterType) {
        self.parameterType = parameterType
        self.delegate = nil
    }
    
    func dateValueChanged(newValue: Date) {
        switch parameterType {
        case .date0:
            delegate?.dateTime0 = newValue
        case .date1:
            delegate?.dateTime1 = newValue
        default: return
        }
    }
    

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard let activityValue = Double(textField.text!) else {
            return
            
        }
        print("Activity value changed \(activityValue)")
        switch parameterType {
        case .activity0:
            delegate?.activity0 = activityValue
        case .activity1:
            delegate?.activity1 = activityValue
        default: return
        }
    }
}

