//
//  IsotopeTableViewController.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-06-09.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class IsotopeTableViewController: UITableViewController {


    var saveButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    
    var parameterList = [IsotopeParameter]()
    
    var isotopeViewModel: IsotopeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveIsotope))
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelEdits))
        
        self.navigationItem.rightBarButtonItems = [saveButton!]
        self.navigationItem.leftBarButtonItem = cancelButton!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadParameterList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parameterList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parameter", for: indexPath) as! IsotopeTableViewCell
        guard let isotopeViewModel = isotopeViewModel else {return cell}
        cell.parameterTitleLabel.text = isotopeViewModel.titleForParameter(parameterList[indexPath.row])
        cell.parameterValueTextField.text = isotopeViewModel.valueForParameter(parameterList[indexPath.row])

        
            cell.parameterValueTextField.isEnabled = isotopeViewModel.isEditable(parameterList[indexPath.row])
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isotopeViewModel?.header()
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return isotopeViewModel?.isEditable(parameterList[indexPath.row]) ?? false
        
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
    
    @objc func saveIsotope() {
    
    
    }
    
    @objc func cancelEdits() {
        performSegue(withIdentifier: "unwind", sender: self)
    }
    
    func loadParameterList() {
        parameterList.append(.atomName)
        parameterList.append(.massNumber)
        parameterList.append(.halfLifeSec)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
