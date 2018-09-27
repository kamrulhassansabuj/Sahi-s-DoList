//
//  ViewController.swift
//  Sahi's DoList
//
//  Created by Kamrul Hassan Sabuj on 25/9/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit

class DoListViewController: UITableViewController{
    
    
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
        loadItems()
        
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
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Do List Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            
            let newItem = Item()
            
            newItem.itemTitel = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
            print(textField.text)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error Encoding Item Array, \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print("errror decoding error \(error)")
            }
        }
    }
}

