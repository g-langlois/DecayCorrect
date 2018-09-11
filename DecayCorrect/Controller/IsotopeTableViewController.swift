//
//  IsotopeTableViewController.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-06-09.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class IsotopeTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    var saveButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    
    var isNew: Bool = false
    
    var parameterList = [[IsotopeParameter]]()
    var cells = [[UITableViewCell]]()

    var isotopeViewModel: IsotopeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveIsotope))
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelEdits))
        
        self.navigationItem.rightBarButtonItems = [saveButton!]
        self.navigationItem.leftBarButtonItem = cancelButton!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadParameterList()
        cells.append([])
        cells.append([])
        for _ in 0...parameterList[0].count {
            cells[0].append(tableView.dequeueReusableCell(withIdentifier: "parameter") as! IsotopeTableViewCell)
        }
        for _ in 0...parameterList[1].count {
            
            cells[1].append(UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "time"))
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameterList[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = cells[indexPath.section][indexPath.row] as! IsotopeTableViewCell
            guard let isotopeViewModel = isotopeViewModel else {return cell}
            cell.parameterTitleLabel.text = isotopeViewModel.titleForParameter(parameterList[indexPath.section][indexPath.row])
            cell.parameterValueTextField.text = isotopeViewModel.valueForParameter(parameterList[indexPath.section][indexPath.row])
            cell.parameterValueTextField.isEnabled = isotopeViewModel.isEditable(parameterList[indexPath.section][indexPath.row])
            if !isotopeViewModel.isEditable(parameterList[indexPath.section][indexPath.row]) {
            }
            return cell
        case 1:
            let cell = cells[indexPath.section][indexPath.row]
            if isotopeViewModel?.isCheckmarkSelected(parameterList[indexPath.section][indexPath.row]) ?? false {
                cell.accessoryType = .checkmark
            }
            cell.textLabel?.text = isotopeViewModel?.titleForParameter(parameterList[indexPath.section][indexPath.row])
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isotopeViewModel?.header(section: section)
    }
    
    
    @objc func saveIsotope() {
        for row in 0 ... (parameterList[0].count - 1) {
        let cell = cells[0][row] as! IsotopeTableViewCell
            isotopeViewModel?.saveValueForParameter(parameterList[0][row], value:  cell.parameterValueTextField.text!)
        }
        performSegue(withIdentifier: "unwind", sender: self)
    
    }
    
    @objc func cancelEdits() {
        performSegue(withIdentifier: "unwind", sender: self)
    }
    
    func loadParameterList() {
        parameterList.append([])
        parameterList.append([])
        parameterList[0].append(.atomName)
        parameterList[0].append(.atomSymbol)
        parameterList[0].append(.massNumber)
        parameterList[0].append(.state)
        parameterList[0].append(.halfLife)
        
        parameterList[1].append(.secSelection)
        parameterList[1].append(.minSelection)
        parameterList[1].append(.hourSelection)
        parameterList[1].append(.daySelection)
        parameterList[1].append(.yearSelection)
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO
     }
 
    
}
