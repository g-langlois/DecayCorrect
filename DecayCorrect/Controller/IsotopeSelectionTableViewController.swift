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
    
    
    var addButton: UIBarButtonItem?
    var editButton: UIBarButtonItem?
    var doneButton: UIBarButtonItem?
    
    var editingIsotope: Isotope?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelectionDuringEditing = true
        
        viewModel = IsotopesViewModel()
        sut = IsotopeStorageManager()
        
        isotopes = sut.fetchAllIsotopes()

        tableView.reloadData()
        
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(IsotopeSelectionTableViewController.addIsotope))
        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editIsotopes))
        doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitEdits))
        
        self.navigationItem.rightBarButtonItems = [editButton!, addButton!]
        
        
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
        cell.isotopeId.text = ("\(isotopes[row].atomSymbol ?? "")-\(isotopes[row].massNumber)\(isotopes[row].state ?? "") ")
        cell.isotopeName.text = ("t1/2= \(isotopes[row].halfLifeSec) s")
        cell.isotopeName.textColor = UIColor.gray
        if selectedIsotopeId != nil && selectedIsotopeId == isotopes[row].uniqueId {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            editingIsotope = isotopes[indexPath.row]
            performSegue(withIdentifier: "editIsotopeSegue", sender: self)
        } else {
            selectedIsotopeId = isotopes[indexPath.row].uniqueId
            updateState()
            tableView.reloadData()
            performSegue(withIdentifier: "unwindSegue", sender: self)
        }
    }
    
    func updateState() {
        if let viewModel = self.viewModel {
            viewModel.selectedIsotopeId = selectedIsotopeId
        }
    }
    
    @objc func addIsotope() {
        performSegue(withIdentifier: "addIsotopeSegue", sender: self)
    }
    
    @objc func editIsotopes() {
        self.navigationItem.rightBarButtonItems = [doneButton!]
        setEditing(true, animated: true)
        
    }
    
    @objc func commitEdits() {
        self.navigationItem.rightBarButtonItems = [editButton!, addButton!]
        setEditing(false, animated:true)
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .insert
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        commitEdits()
        guard let isotopeViewController = segue.destination as? IsotopeTableViewController else {return}
        
        switch segue.identifier {
        case "addIsotopeSegue":
            isotopeViewController.isotopeViewModel = IsotopeViewModel()
        case "editIsotopeSegue":
            isotopeViewController.isotopeViewModel = IsotopeViewModel(editingIsotope)
        default:
            break
        }
        
        
    }
    
    @IBAction func unwindFromIsotopeEdit(segue: UIStoryboardSegue) {
        
        tableView.reloadData()
    }

}
