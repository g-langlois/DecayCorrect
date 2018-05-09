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
 -select the isotope
 -reference activity and units,
 -reference date/time
 -targets (date/time or activity and its units)
 Upon entering three inputs, the last remaining field is populated with the result.
 Clear button clears everything except isotope and units
 
 */
class DecayTableViewController: UITableViewController, DecayCalculatorDelegate {

    // MARK: - Properties
    
    var resultAvailable = true
    
    var pickerType: PickerType?
    
    var pickerIndexPath:IndexPath?
    var activePicker: ParameterType?
    var datePickerDate: Date?
    var unitsPickerUnit: RadioactivityUnit?
    
    var activity0ViewModel = ParameterViewModel(parameterType: .activity0)
    var activity0UnitsViewModel = UnitsViewModel(parameterType: .activity0)
    var datePicker0ViewModel = DatePickerViewModel(parameterType: .date0)
    var dateTime0ViewModel = ParameterViewModel(parameterType: .date0)
    var activity1ViewModel = ParameterViewModel(parameterType: .activity1)
    var activity1UnitsViewModel = UnitsViewModel(parameterType: .activity1)
    var datePicker1ViewModel = DatePickerViewModel(parameterType: .date1)
    var dateTime1ViewModel = ParameterViewModel(parameterType: .date0)
    
    var activity0IndexPath = IndexPath(row: 0, section: 1)
    var dateTime0IndexPath = IndexPath(row: 1, section: 1)
    var activity1IndexPath = IndexPath(row: 0, section: 2)
    var dateTime1IndexPath = IndexPath(row: 2, section: 1)
    
    let calculator = DecayCalculator()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity0ViewModel.delegate = calculator
        activity0UnitsViewModel.delegate = calculator
        activity1ViewModel.delegate = calculator
        activity1UnitsViewModel.delegate = calculator
        datePicker1ViewModel.delegate = calculator
        datePicker0ViewModel.delegate = calculator
        calculator.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIsotopeIndex = calculator.selectedIsotopeIndex  {
            calculator.isotope = calculator.isotopes[selectedIsotopeIndex]
            tableView.reloadData()
        }
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
            numberOfRows = 1
        case 1:
            if resultAvailable == true && pickerIndexPath == nil {
                numberOfRows = 3
            } else if !resultAvailable && pickerIndexPath == nil {
                numberOfRows = 4
            } else if resultAvailable && pickerIndexPath != nil && pickerIndexPath!.section == 1 {
                numberOfRows = 4
            }
            else if resultAvailable && pickerIndexPath != nil && pickerIndexPath!.section != 1 {
                numberOfRows = 3
            }
            else {
                numberOfRows = 5
            }
        case 2:
            if pickerIndexPath != nil && pickerIndexPath!.section == 2 {
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
            return ""
        case 1:
            return "Inputs (any three)"
        case 2:
            return "Result"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let pickerIndexPath = pickerIndexPath, let pickerType = pickerType, indexPath == pickerIndexPath{
            switch pickerType {
            case .date:
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePicker", for: indexPath) as! DatePickerTableViewCell
                if let activeDatePicker = activePicker {
                    switch activeDatePicker {
                    case .date0:
                        cell.delegate = datePicker0ViewModel
                        if let date = calculator.dateTime0 {
                            
                            cell.datePicker.date = date
                        }
                        else {
                            cell.datePicker.date = Date()
                            calculator.dateTime0 = Date()
                            tableView.reloadData()
                        }
                    case .date1:
                        cell.delegate = datePicker1ViewModel
                        if let date = calculator.dateTime1 {
                            
                            cell.datePicker.date = date
                        }
                        else {
                            cell.datePicker.date = Date()
                            calculator.dateTime1 = Date()
                            tableView.reloadData()
                        }
                    default:
                        cell.delegate = nil
                    }
                    
                }
                return cell
            case .unit:
                let cell = tableView.dequeueReusableCell(withIdentifier: "unitsPicker", for: indexPath) as! UnitsPickerTableViewCell
                if let activeDatePicker = activePicker {
                    switch activeDatePicker {
                    case .activity0:
                        cell.unitsPicker.delegate = activity0UnitsViewModel
                        cell.unitsPicker.dataSource = activity0UnitsViewModel
                    case .activity1:
                        cell.unitsPicker.delegate = activity1UnitsViewModel
                        cell.unitsPicker.dataSource = activity1UnitsViewModel
                    default:
                        cell.delegate = nil
                    }
                    
                }
                
                
                return cell
            }
            
            
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "parameter", for: indexPath) as! ParameterTableViewCell
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            cell.parameterLabel.text = "Isotope"
            cell.parameterValueTextField.isHidden = true
            cell.unitsLabel.text = calculator.isotope?.shortName ?? "Select isotope"
            
            
        case dateTime0IndexPath:
            cell.parameterLabel.text = "Date (t0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.isEnabled = false
            cell.parameterValueTextField.placeholder = "Select date"
            cell.unitsLabel.text = ""
            if let dateTime = calculator.dateTime0 {
                cell.parameterValueTextField.text = dateTime0ViewModel.formatDate(dateTime)
            }
            
        case activity0IndexPath:
            cell.parameterLabel.text = "Activity (A0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Enter activity"
            cell.parameterValueTextField.delegate = activity0ViewModel
            if let unitsLabel = calculator.activity0Units {
                cell.unitsLabel.text = unitsLabel.rawValue
            }
            else {
                cell.unitsLabel.text = ""
            }
            
            
        case dateTime1IndexPath:
            cell.parameterLabel.text = "Date (t1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Select date"
            cell.parameterValueTextField.isEnabled = false
            cell.unitsLabel.text = ""
            if let dateTime = calculator.dateTime1 {
                cell.parameterValueTextField.text = dateTime1ViewModel.formatDate(dateTime)
            }
            
        case activity1IndexPath:
            cell.parameterLabel.text = "Activity (A1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Enter activity"
            cell.parameterValueTextField.delegate = activity1ViewModel
            cell.unitsLabel.text = ""
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.maximumFractionDigits = 3
            formatter.minimumFractionDigits = 0
            
            if calculator.activity1 != nil {
                cell.parameterValueTextField.text = formatter.string(for: calculator.activity1)
                if let unitsLabel = calculator.activity1Units {
                    cell.unitsLabel.text = unitsLabel.rawValue
                }
                else {
                    cell.unitsLabel.text = ""
                    
                }
            }
            
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            performSegue(withIdentifier: "selectIsotope", sender: self)
        case correctedIndexPath(from: dateTime0IndexPath):
            datePickerDate = calculator.dateTime0
            activePicker = .date0
            togglePicker(ofType: .date, after: indexPath)
            
        case correctedIndexPath(from: dateTime1IndexPath):
            datePickerDate = calculator.dateTime1
            activePicker = .date1
            togglePicker(ofType: .date, after: indexPath)
            
        case correctedIndexPath(from: activity0IndexPath):
            unitsPickerUnit = calculator.activity0Units
            activePicker = .activity0
            togglePicker(ofType: .unit, after: indexPath)
            
        case correctedIndexPath(from: activity1IndexPath):
            unitsPickerUnit = calculator.activity1Units
            activePicker = .activity1
            togglePicker(ofType: .unit, after: indexPath)
            
            
        default:
            hidePickers()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = tableView.rowHeight
        if let dpIndexPath = pickerIndexPath, indexPath == dpIndexPath{
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: "datePicker") as! DatePickerTableViewCell
            rowHeight =  datePickerCell.datePicker.frame.height
        }
        return rowHeight
    }
    
    // MARK: - Pickers
    
    private func correctedIndexPath(from indexPath: IndexPath) -> IndexPath {
        var correctedIndexPath = indexPath
        if let pickerIndexPath = pickerIndexPath {
            if indexPath.section == pickerIndexPath.section {
                if indexPath.row > pickerIndexPath.section {
                    correctedIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                }
            }
        }
        return correctedIndexPath
    }
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    private func togglePicker(ofType pickerType: PickerType, after indexPath: IndexPath) {
        
        tableView.beginUpdates()
        if (pickerIndexPath != nil && pickerIndexPath == indexPath) {
            return
        } else if (pickerIndexPath != nil) {
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            pickerIndexPath = nil
            datePickerDate = nil
            unitsPickerUnit = nil
            self.pickerType = nil
            
        } else  {
            
            pickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [pickerIndexPath!], with: .fade)
            self.pickerType = pickerType
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
    
    private func hidePickers() {
        tableView.beginUpdates()
        if (pickerIndexPath != nil) {
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            pickerIndexPath = nil
        }
        datePickerDate = nil
        unitsPickerUnit = nil
        
        activePicker = nil
        tableView.endUpdates()
    }
    

    
    
    // MARK: - Logic
    private func splitInputToResultSection() {
        //TODO
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IsotopeSelectionTableViewController {
            destination.state = calculator
        }
    }
    
    
    func decayCalculatorDataChanged() {
        tableView.reloadData()
    }
    
}


