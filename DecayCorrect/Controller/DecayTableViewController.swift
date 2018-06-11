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
class DecayTableViewController: UITableViewController, DecayCalculatorViewModelDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Properties
    
    var resultAvailable = true
    
    var pickerType: CellType?
    
    var pickerIndexPath:IndexPath?
    var activePicker: DecayCalculatorInput?
    var datePickerDate: Date?
    var unitsPickerUnit: RadioactivityUnit?
    
    var activity0IndexPath = IndexPath(row: 0, section: 1)
    var dateTime0IndexPath = IndexPath(row: 1, section: 1)
    var activity1IndexPath = IndexPath(row: 0, section: 2)
    var dateTime1IndexPath = IndexPath(row: 2, section: 1)
    
    let calculatorViewModel = DecayCalculatorViewModel()
    
    let sut = IsotopeStorageManager()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorViewModel.delegate = self
        initUnitPickerData()
        let clearButton = UIBarButtonItem(title: "Clear", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clearTable))
        self.navigationItem.rightBarButtonItems = [clearButton]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculatorViewModel.decayCalculatorDataChanged()
        tableView.reloadData()
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
                numberOfRows = 5
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
            return "Isotope"
        case 1:
            return "Inputs"
        case 2:
            return "Result"
        default:
            return nil
        }
    }
    
    fileprivate func dequeueActivityCell(_ tableView: UITableView, _ indexPath: IndexPath, source: DecayCalculatorInput) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parameter", for: indexPath) as! ParameterTableViewCell
        cell.parameterValueTextField.text = calculatorViewModel.formatedActivity(forSource: source)
        cell.parameterLabel.text = "Activity (A\(source.id))"
        cell.accessoryType = .none
        cell.parameterValueTextField.placeholder = "Activity"
        cell.parameterValueTextField.delegate = self
        cell.parameterValueTextField.tag = calculatorViewModel.tagForSource(source)
        cell.unitsLabel.text = calculatorViewModel.formatedUnits(forSource: source)
        if !calculatorViewModel.isUnitsAvailableForSource(source) {
            cell.unitsLabel.textColor = UIColor.lightGray
        } else if let pickerRow = pickerIndexPath?.row, pickerRow == correctedIndexPath(from: indexPath).row + 1{
            cell.unitsLabel?.textColor = UIColor.red
        }
        else {
            cell.unitsLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    fileprivate func dequeueDateCell(_ tableView: UITableView, _ indexPath: IndexPath, source: DecayCalculatorInput) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "date", for: indexPath)
        cell.textLabel?.text = "Date (t\(source.id))"
        cell.detailTextLabel?.tag = calculatorViewModel.tagForSource(source)
        cell.detailTextLabel?.text = calculatorViewModel.formatedDateForSource(source)
        
        if !calculatorViewModel.isDateAvailableForSource(source) {
            cell.detailTextLabel?.textColor = UIColor.lightGray
        } else if let pickerRow = pickerIndexPath?.row, pickerRow == correctedIndexPath(from: indexPath).row + 1{
            cell.detailTextLabel?.textColor = UIColor.red
        }
        else
        {
            cell.detailTextLabel?.textColor = UIColor.black
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let pickerIndexPath = pickerIndexPath, let pickerType = pickerType, indexPath == pickerIndexPath{
            switch pickerType {
            case .datePicker:
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePicker", for: indexPath) as! DatePickerTableViewCell
                if let activePicker = activePicker {
                    cell.delegate = self
                    cell.datePicker.tag = calculatorViewModel.tagForSource(activePicker)
                    if let date = calculatorViewModel.dateForSource(activePicker) {
                        cell.datePicker.date = date
                    }
                    else {
                        cell.datePicker.date = Date()
                        calculatorViewModel.setDate(Date(), forSource: activePicker)
                    }
                    
                    // Delay required to avoid breaking the animation when inserting the row
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        tableView.reloadRows(at: [IndexPath(row: indexPath.row - 1, section: indexPath.section)], with: .none)
                    }
                }
                return cell
            case .unitPicker:
                let cell = tableView.dequeueReusableCell(withIdentifier: "unitsPicker", for: indexPath) as! UnitsPickerTableViewCell
                if let activePicker = activePicker {
                    
                    cell.unitsPicker.tag = calculatorViewModel.tagForSource(activePicker)
                    cell.unitsPicker.delegate = self
                    cell.unitsPicker.dataSource = self
                }
                return cell
            default:
                break
            }
        }
        
        
        
        switch indexPath {
        case correctedIndexPath(from: IndexPath(row: 0, section: 0)):
            let cell = tableView.dequeueReusableCell(withIdentifier: "isotope", for: indexPath)
            cell.textLabel?.text = calculatorViewModel.isotopeShortName
            cell.detailTextLabel?.text = "t1/2 = \(calculatorViewModel.halfLifeSec) s"
            cell.detailTextLabel?.textColor = UIColor.gray
            return cell
        case correctedIndexPath(from: dateTime0IndexPath):
            return dequeueDateCell(tableView, indexPath, source: .date0)
        case correctedIndexPath(from: activity0IndexPath):
            return dequeueActivityCell(tableView, indexPath,source: .activity0)
        case correctedIndexPath(from: dateTime1IndexPath):
            return dequeueDateCell(tableView, indexPath, source: .date1)
        case correctedIndexPath(from: activity1IndexPath):
            return dequeueActivityCell(tableView, indexPath,source: .activity1)
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: "parameter", for: indexPath) as! ParameterTableViewCell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            performSegue(withIdentifier: "selectIsotope", sender: self)
        case correctedIndexPath(from: dateTime0IndexPath):
            datePickerDate = calculatorViewModel.calculator.dateTime0
            activePicker = DecayCalculatorInput.date0
            togglePicker(ofType: .datePicker, after: indexPath)
            
        case correctedIndexPath(from: dateTime1IndexPath):
            datePickerDate = calculatorViewModel.calculator.dateTime1
            activePicker = DecayCalculatorInput.date1
            togglePicker(ofType: .datePicker, after: indexPath)
            
        case correctedIndexPath(from: activity0IndexPath):
            unitsPickerUnit = calculatorViewModel.calculator.activity0Units
            activePicker = DecayCalculatorInput.activity0
            togglePicker(ofType: .unitPicker, after: indexPath)
            
        case correctedIndexPath(from: activity1IndexPath):
            unitsPickerUnit = calculatorViewModel.calculator.activity1Units
            activePicker = DecayCalculatorInput.activity1
            togglePicker(ofType: .unitPicker, after: indexPath)
            
        default:
            hidePickers()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = tableView.rowHeight
        if let dpIndexPath = pickerIndexPath, indexPath == dpIndexPath{
            let datePickerCell = self.tableView.dequeueReusableCell(withIdentifier: "datePicker") as! DatePickerTableViewCell
            rowHeight =  datePickerCell.datePicker.frame.height
        }
        return rowHeight
    }

    
    // MARK: - Pickers
    
    private func correctedIndexPath(from indexPath: IndexPath) -> IndexPath {
        var correctedIndexPath = indexPath
        if let pickerIndexPath = pickerIndexPath {
            if indexPath.section == pickerIndexPath.section {
                if indexPath.row >= pickerIndexPath.row {
                    correctedIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                }
            }
        }
        return correctedIndexPath
    }
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    private func togglePicker(ofType pickerType: CellType, after indexPath: IndexPath) {
        
        tableView.beginUpdates()
        
        if (pickerIndexPath != nil && pickerIndexPath == indexPath) {
            return
        } else if (pickerIndexPath != nil) {
            tableView.deleteRows(at: [pickerIndexPath!], with: .fade)
            pickerIndexPath = nil
            datePickerDate = nil
            unitsPickerUnit = nil
            self.pickerType = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.reloadData()
            }
            
        } else  {
            self.pickerType = pickerType
            pickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [pickerIndexPath!], with: .fade)
            
            
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        // To get third section appear:
        //resultAvailable = true
        // let indexSet = IndexSet.init()
        //indexSet.insert(2)
        //tableView.insertSections(indexSet, with: .fade)
        //
        
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    
    
    
    // MARK: - Logic
    private func splitInputToResultSection() {
        //TODO
    }
    
    
    @IBAction func unwindFromIsotopeSelection(segue: UIStoryboardSegue) {
        
        calculatorViewModel.isotopeSelectionChanged()
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hidePickers()
    }
    
    
    func decayCalculatorViewModelChanged() {
        tableView.reloadData()
        
        
    }
    
    
    // MARK: - Text field delegate
    
    // Hides soft keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        hidePickers()
        return false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        guard let activityValue = Double(textField.text!) else {
            return
            
        }
        hidePickers()
        switch textField.tag {
        case calculatorViewModel.activity0ViewModel.source.tag:
            calculatorViewModel.calculator.activity0 = activityValue
        case calculatorViewModel.activity1ViewModel.source.tag:
            calculatorViewModel.calculator.activity1 = activityValue
        default: return
        }
        calculatorViewModel.calculator.updateResult()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return true
        } else if textField.text!.contains(".") {
            return false
        } else if CharacterSet(charactersIn: ".").isSuperset(of:  CharacterSet(charactersIn: string)) {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Date picker delegates
    
    func dateValueChanged(newValue: Date, forPickerWithTag tag: Int) {
        switch tag {
        case calculatorViewModel.date0ViewModel.source.tag:
            calculatorViewModel.calculator.dateTime0 = newValue
        case calculatorViewModel.date1ViewModel.source.tag:
            calculatorViewModel.calculator.dateTime1 = newValue
        default: return
        }
        
        calculatorViewModel.calculator.updateResult()
        
    }
    
    
    // MARK: Unit picker delegates
    
    var pickerData = [RadioactivityUnit]()
    
    func initUnitPickerData() {
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
        switch pickerView.tag {
        case calculatorViewModel.activity0ViewModel.source.tag:
            calculatorViewModel.calculator.activity0Units = pickerData[row]
        case calculatorViewModel.activity1ViewModel.source.tag:
            calculatorViewModel.calculator.activity1Units = pickerData[row]
        default: return
        }
        calculatorViewModel.calculator.updateResult()
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].rawValue
    }
    
    @objc func clearTable() {
        pickerType = nil
        pickerIndexPath = nil
        activePicker = nil
        datePickerDate = nil
        calculatorViewModel.resetModel()
        tableView.reloadData()
        
    }

    
}


