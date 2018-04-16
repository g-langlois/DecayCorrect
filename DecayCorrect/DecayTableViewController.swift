//
//  DecayTableViewController.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

/*
 TableViewController responsible for input the following:
    -select the isotope and the units
    -reference activity,
    -reference date/time
    -targets (date/time or activity)
 Upon entering three inputs, the last remaining field is populated with the result.
 Clear button clears everything except isotope and units
 
 */
class DecayTableViewController: UITableViewController {
    
    // MARK: - Properties
    let decayModel = DecayModel()
    
    var resultAvailable = true
    var targetParameter: ParameterType?
    
    var datePickerIndexPath:IndexPath?
    var activeDatePicker: ParameterType?
    var datePickerDate: Date?
    
    var activity0: Double?
    var dateTime0: Date?
    var activity1: Double?
    var dateTime1: Date?
    
    
    var activity0Delegate = ParameterViewModel(parameterType: .activity0)
    var dateTime0Delegate = ParameterViewModel(parameterType: .date0)
    var activity1Delegate = ParameterViewModel(parameterType: .activity1)
    var dateTime1Delegate = ParameterViewModel(parameterType: .date1)
    
    var activity0IndexPath = IndexPath(row: 0, section: 1)
    var dateTime0IndexPath = IndexPath(row: 1, section: 1)
    var activity1IndexPath = IndexPath(row: 0, section: 2)
    var dateTime1IndexPath = IndexPath(row: 2, section: 1)
    
    
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
            if let activeDatePicker = activeDatePicker {
                switch activeDatePicker {
                case .date0:
                    datePickerCell.delegate = dateTime0Delegate
                case .date1:
                    datePickerCell.delegate = dateTime1Delegate
                default:
                    datePickerCell.delegate = nil
                }
            }
            
            return datePickerCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "parameter", for: indexPath) as! ParameterTableViewCell
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            cell.parameterLabel.text = "Isotope"
            cell.parameterValueTextField.isHidden = true
            cell.unitsLabel.text = "F18"
            
        case IndexPath(row: 1, section: 0):
            cell.parameterLabel.text = "Units"
            cell.parameterValueTextField.isHidden = true
            cell.unitsLabel.text = "GBq"
            
        case dateTime0IndexPath:
            cell.parameterLabel.text = "Date (t0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.isEnabled = false
            cell.parameterValueTextField.placeholder = "Date"
            cell.unitsLabel.text = ""
            if let dateTime = dateTime0 {
                cell.parameterValueTextField.text = formatDate(dateTime)
            }
            
        case activity0IndexPath:
            cell.parameterLabel.text = "Activity (A0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Activity"
            cell.parameterValueTextField.delegate = activity0Delegate
            cell.unitsLabel.textColor = UIColor.lightGray
            cell.unitsLabel.text = ""
            
            
        case dateTime1IndexPath:
            cell.parameterLabel.text = "Date (t1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Date"
            cell.parameterValueTextField.isEnabled = false
            cell.unitsLabel.text = ""
            if let dateTime = dateTime1 {
                cell.parameterValueTextField.text = formatDate(dateTime)
            }
            
        case activity1IndexPath:
            cell.parameterLabel.text = "Activity (A1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Activity"
            cell.parameterValueTextField.delegate = activity1Delegate
            cell.unitsLabel.textColor = UIColor.lightGray
            cell.unitsLabel.text = ""
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            
            if activity1 != nil {
                cell.parameterValueTextField.text = formatter.string(for: activity1)
            }
            
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case correctIndexPathWithDatePicker(for: dateTime0IndexPath):
            datePickerDate = dateTime0
            activeDatePicker = .date0
            toggleDatePicker(for: indexPath)
        case correctIndexPathWithDatePicker(for: dateTime1IndexPath):
            datePickerDate = dateTime1
            activeDatePicker = .date1
            toggleDatePicker(for: indexPath)
            
        default:
            hideDatePicker()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = tableView.rowHeight
        if let dpIndexPath = datePickerIndexPath, indexPath == dpIndexPath{
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: "datePicker") as! DatePickerTableViewCell
            rowHeight =  datePickerCell.datePicker.frame.height
        }
        return rowHeight
    }

    // MARK: - Date Picker

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
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
        activeDatePicker = nil
        tableView.endUpdates()
    }
    
    
    // MARK: - Data formating
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - Logic
    
    private func splitInputToResultSection() {
        //TODO
    }
    
    
    func setTarget() {
            var parameterType: ParameterType?
                var count = 0
                if activity0 == nil {
                    count += 1
                    parameterType = .activity0
                }
                if activity1 == nil {
                    count += 1
                    parameterType = .activity1
                }
                if dateTime0 == nil {
                    count += 1
                    parameterType = .date0
                }
                if dateTime1 == nil {
                    count += 1
                    parameterType = .date1
                }
        if count == 1 {
            targetParameter = parameterType

        }
        
    
    }
    func parameterUpdate() {
        
        setTarget()
        guard let targetParameter = targetParameter else {
            tableView.reloadData()
            return
            
        }
        let isotope1 = Isotope(atomName: "Fluoride", atomSymbol: "F", halfLife: TimeInterval(110*60), massNumber: 18)
        
        
        if targetParameter == .activity1, let activity0 = activity0, let dateTime0 = dateTime0, let dateTime1 = dateTime1 {
            let initialRadioactivity = Radioactivity(time: dateTime0, countRate: activity0, units: RadioactivityUnit.bq)
            let radioactiveSubstance = RadioactiveSubstance(isotope: isotope1, radioactivity: initialRadioactivity)
            activity1 = radioactiveSubstance.correct(to: dateTime1)?.countRate
        }
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
    
    // Hides soft keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate!.view.endEditing(true)
        return false
    }
    
    func dateValueChanged(newValue: Date) {
        switch parameterType {
        case .date0:
            delegate?.dateTime0 = newValue
        case .date1:
            delegate?.dateTime1 = newValue
        default: return
        }
        if delegate != nil {
            delegate!.parameterUpdate()
        }
    }
    

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard let activityValue = Double(textField.text!) else {
            return
            
        }
        switch parameterType {
        case .activity0:
            delegate?.activity0 = activityValue
        case .activity1:
            delegate?.activity1 = activityValue
        default: return
        }
        if delegate != nil {
            delegate!.parameterUpdate()
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
}

