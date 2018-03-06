//
//  DecayTableViewController.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-02-17.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class DecayTableViewController: UITableViewController {
    
    var resultAvailable = true
    var datePickerIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        if let indexPath = datePickerIndexPath {
            return tableView.dequeueReusableCell(withIdentifier: "datePicker", for: indexPath)
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "parameter", for: indexPath) as! ParameterTableViewCell
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            cell.parameterLabel.text = "Isotope"
            cell.parameterValueTextField.placeholder = "Isotope"
            
        case IndexPath(row: 1, section: 0):
            cell.parameterLabel.text = "Units"
            cell.parameterValueTextField.placeholder = "Units"
            
        case dateTime0IndexPath:
            cell.parameterLabel.text = "Date & time (t0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.isEnabled = false
            cell.parameterValueTextField.placeholder = "Date & time"
            
        case activity0IndexPath:
            cell.parameterLabel.text = "Activity (A0)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Activity"
            
        case dateTime1IndexPath:
            cell.parameterLabel.text = "Date & time (t1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Date & time"
            
        case activity1IndexPath:
            cell.parameterLabel.text = "Activity (A1)"
            cell.accessoryType = .none
            cell.parameterValueTextField.placeholder = "Activity"
        default:
                break
        }
        return cell
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
    
    enum CellDataType {
        case date
        case activity
    }
    
    var activity0: RadioactiveSubstance?
    var activity0IndexPath = IndexPath(row: 0, section: 1)
    
    
    var dateTime0: Date?
    var dateTime0IndexPath = IndexPath(row: 1, section: 1)
    
    var activity1: RadioactiveSubstance?
    var activity1IndexPath = IndexPath(row: 2, section: 1)
    
    var dateTime1: Date?
    var dateTime1IndexPath = IndexPath(row: 0, section: 2)
    
    
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
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func toggleDatePicker(for indexPath: IndexPath) {
        tableView.beginUpdates()
        if (datePickerIndexPath != nil && datePickerIndexPath == indexPath) {
            return
        } else if (datePickerIndexPath != nil && datePickerIndexPath == IndexPath(row: indexPath.row + 1, section: indexPath.section)) {
            tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
        } else if (datePickerIndexPath != nil) {
             tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
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
        
        tableView.endUpdates()
    }
    
    private func splitInputToResultSection() {
        //TODO
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
