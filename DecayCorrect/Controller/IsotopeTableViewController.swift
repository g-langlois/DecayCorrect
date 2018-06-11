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
    
    var parameterList = [[IsotopeParameter]]()
    var cells = [[IsotopeTableViewCell]]()

    var isotopeViewModel: IsotopeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveIsotope))
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelEdits))
        
        self.navigationItem.rightBarButtonItems = [saveButton!]
        self.navigationItem.leftBarButtonItem = cancelButton!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cells.append([])
        cells.append([])
        for _ in 0...2 {
            cells[0].append(tableView.dequeueReusableCell(withIdentifier: "parameter") as! IsotopeTableViewCell)
        }
        loadParameterList()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameterList[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.section][indexPath.row]
        guard let isotopeViewModel = isotopeViewModel else {return cell}
        cell.parameterTitleLabel.text = isotopeViewModel.titleForParameter(parameterList[indexPath.section][indexPath.row])
        cell.parameterValueTextField.text = isotopeViewModel.valueForParameter(parameterList[indexPath.section][indexPath.row])
        cell.parameterValueTextField.isEnabled = isotopeViewModel.isEditable(parameterList[indexPath.section][indexPath.row])
        if !isotopeViewModel.isEditable(parameterList[indexPath.section][indexPath.row]) {
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isotopeViewModel?.header()
    }
    
    
    @objc func saveIsotope() {
    
    
    }
    
    @objc func cancelEdits() {
        performSegue(withIdentifier: "unwind", sender: self)
    }
    
    func loadParameterList() {
        parameterList.append([])
        parameterList.append([])
        parameterList[0].append(.atomName)
        parameterList[0].append(.massNumber)
        parameterList[0].append(.halfLifeSec)
        
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO
     }
 
    
}

class IsotopeTableViewCellValue: IsotopeTableViewCellDelegate {
    var value = ""
    
    func editingDidEnd(_ value: String) {
        self.value = value
    }
    
    
}
