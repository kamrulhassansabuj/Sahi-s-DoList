//
//  ViewController.swift
//  Sahi's DoList
//
//  Created by Kamrul Hassan Sabuj on 25/9/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit

class DoListViewController: UITableViewController {
    
   
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let items = defaults.array(forKey: "DoListArray") as? [Item] {
            itemArray = items
        }
        
        let newItem = Item()
        newItem.itemTitel = "Call Mom"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.itemTitel = "Buy Eggs"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.itemTitel = "Buy Shirt For Tuhin"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.itemTitel = "Go to Jamuna Muture Park"
        itemArray.append(newItem3)
        
        
    }
    
    //MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = tableView.dequeueReusableCell(withIdentifier: "DoListItemCell", for: indexPath)
       
        let currentItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.itemTitel
        
        //Ternary Operation
        //value = condition ? valueTrue : valueFalse
        
        cell.accessoryType = currentItem.checkDone ? .checkmark : .none
        
//        if currentItem.checkDone == true {
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].checkDone = !itemArray[indexPath.row].checkDone
    
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Do List Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
            print(textField.text)
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            
            let newItem5 = Item()
            
            newItem5.itemTitel = textField.text!
            
            self.itemArray.append(newItem5)
            
            self.defaults.set(self.itemArray, forKey: "DoListArray")
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

