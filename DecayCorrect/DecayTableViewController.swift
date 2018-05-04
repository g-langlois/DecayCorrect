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
class DecayTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var resultAvailable = true
    var targetParameter: ParameterType?
    var pickerType: PickerType?
    
    var pickerIndexPath:IndexPath?
    var activePicker: ParameterType?
    var datePickerDate: Date?
    var unitsPickerUnit: RadioactivityUnit?
    
    var isotope: Isotope?
    var activity0: Double?
    var dateTime0: Date?
    var activity0Units: RadioactivityUnit?
    var activity1: Double?
    var dateTime1: Date?
    var activity1Units: RadioactivityUnit?
    
    
    var activity0Delegate = ParameterViewModel(parameterType: .activity0)
    var activity0UnitsDelegate = UnitsViewModel(parameterType: .activity0)
    var dateTime0Delegate = ParameterViewModel(parameterType: .date0)
    var activity1Delegate = ParameterViewModel(parameterType: .activity1)
    var activity1UnitsDelegate = UnitsViewModel(parameterType: .activity1)
    var dateTime1Delegate = ParameterViewModel(parameterType: .date1)
    
    var activity0IndexPath = IndexPath(row: 0, section: 1)
    var dateTime0IndexPath = IndexPath(row: 1, section: 1)
    var activity1IndexPath = IndexPath(row: 0, section: 2)
    var dateTime1IndexPath = IndexPath(row: 2, section: 1)
    
    let state = State()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity0Delegate.delegate = self
        activity0UnitsDelegate.delegate = self
        activity1Delegate.delegate = self
        activity1UnitsDelegate.delegate = self
        dateTime1Delegate.delegate = self
        dateTime0Delegate.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIsotopeIndex = state.selectedIsotopeIndex  {
            self.isotope = state.isotopes[selectedIsotopeIndex]
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
                        cell.delegate = dateTime0Delegate
                    case .date1:
                        cell.delegate = dateTime1Delegate
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
                        cell.unitsPicker.delegate = activity0UnitsDelegate
                        cell.unitsPicker.dataSource = activity0UnitsDelegate
                    case .activity1:
                        cell.unitsPicker.delegate = activity1UnitsDelegate
                        cell.unitsPicker.dataSource = activity1UnitsDelegate
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
            cell.unitsLabel.text = isotope?.shortName ?? ""
            
            
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
            if let unitsLabel = activity0Units {
                cell.unitsLabel.text = unitsLabel.rawValue
            }
            else {
                cell.unitsLabel.text = ""
            }
            
            
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
            cell.unitsLabel.text = ""
            
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            
            if activity1 != nil {
                cell.parameterValueTextField.text = formatter.string(for: activity1)
                if let unitsLabel = activity1Units {
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
            datePickerDate = dateTime0
            activePicker = .date0
            togglePicker(ofType: .date, after: indexPath)
       
        case correctedIndexPath(from: dateTime1IndexPath):
            datePickerDate = dateTime1
            activePicker = .date1
            togglePicker(ofType: .date, after: indexPath)
            
        case correctedIndexPath(from: activity0IndexPath):
            unitsPickerUnit = activity0Units
            activePicker = .activity0
            togglePicker(ofType: .unit, after: indexPath)
        
        case correctedIndexPath(from: activity1IndexPath):
                unitsPickerUnit = activity1Units
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
        guard let isotope1 = isotope else {
            return
        }
        
        if targetParameter == .activity1, let activity0 = activity0, let dateTime0 = dateTime0, let dateTime1 = dateTime1 {
            let initialRadioactivity = Radioactivity(time: dateTime0, countRate: activity0, units: activity0Units)
            let radioactiveSubstance = RadioactiveSubstance(isotope: isotope1, radioactivity: initialRadioactivity)
            let activity = radioactiveSubstance.correct(to: dateTime1, with: activity1Units)
            activity1 = activity?.countRate
            activity1Units = activity?.units
        }
        tableView.reloadData()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? IsotopeSelectionTableViewController {
                destination.state = state
        }
    }
    

    
}

enum ParameterType {
    case activity0
    case activity1
    case date0
    case date1
}

enum PickerType {
    case date
    case unit
}

class UnitsViewModel: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var delegate: DecayTableViewController?
    var parameterType: ParameterType
    var pickerData = [RadioactivityUnit]()
    
    init(parameterType: ParameterType) {
        self.parameterType = parameterType
        self.delegate = nil
        pickerData.append(.bq)
        pickerData.append(.mbq)
        pickerData.append(.gbq)
        pickerData.append(.uci)
        pickerData.append(.mci)
        pickerData.append(.ci)
        
        
    }
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch parameterType {
        case .activity0:
            delegate?.activity0Units = pickerData[row]
        case .activity1:
            delegate?.activity1Units = pickerData[row]
        default: return
        }
        if delegate != nil {
            delegate!.parameterUpdate()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
    
    
    
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

