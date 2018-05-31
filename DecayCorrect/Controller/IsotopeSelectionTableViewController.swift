//
//  IsotopeSelectionTableViewController.swift
//  DecayCorrect
//
//  Created by Guillaume Langlois on 2018-05-02.
//  Copyright © 2018 Guillaume Langlois. All rights reserved.
//

import UIKit

class IsotopeSelectionTableViewController: UITableViewController {

    var viewModel: IsotopesViewModel?
    var sut: IsotopeStorageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = IsotopesViewModel()
        sut = IsotopeStorageManager()
        
        if !sut.isJsonInitiated() {
            let url = Bundle.main.url(forResource: "nuclides", withExtension: "json")
            _ = sut.populateIsotopes(jsonUrl: url!)
            sut.save()
        }
        
        let fetchedIsotopes = sut.fetchAllIsotopes()
        for isotope in fetchedIsotopes {
            isotopes.append(isotope)
        }
        tableView.reloadData()
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let viewModel = self.viewModel {
            selectedIsotopeId = viewModel.selectedIsotopeId
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedIsotopeId: UUID?
    var isotopes = [Isotope]()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return isotopes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "isotopeCell", for: indexPath) as! IsotopeSelectionTableViewCell
        let row = indexPath.row
        cell.isotopeName.text = ("\(isotopes[row].atomSymbol ?? "")\(isotopes[row].massNumber)  Half-life: \(isotopes[row].halfLifeSec) s")
        if selectedIsotopeId != nil && selectedIsotopeId == isotopes[row].uniqueId {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIsotopeId = isotopes[indexPath.row].uniqueId
        tableView.reloadData()
        updateState()
        performSegue(withIdentifier: "unwindSegue", sender: self)
        
    }
    
    func updateState() {
        if let viewModel = self.viewModel {
            viewModel.selectedIsotopeId = selectedIsotopeId
        }
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
