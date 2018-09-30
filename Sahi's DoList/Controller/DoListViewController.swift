//
//  ViewController.swift
//  Sahi's DoList
//
//  Created by Kamrul Hassan Sabuj on 25/9/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit
import CoreData

class DoListViewController: UITableViewController{
    
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
    }
    
    //MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoListItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = currentItem.itemTitle
        
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
        
        //itemArray[indexPath.row].setValue("Updated value", forKey: "itemTitle") // update from context
        
        itemArray[indexPath.row].checkDone = !itemArray[indexPath.row].checkDone
        //        context.delete(itemArray[indexPath.row]) // Remove from context
        //        itemArray.remove(at: indexPath.row) // Remove from itemArray
        //
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
            
            
            
            let newItem = Item(context: self.context)
            newItem.parentCategory = self.selectedCategory
            newItem.itemTitle = textField.text!
            newItem.checkDone = false
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
        
        do {
            try context.save()
        }
        catch{
            print("Error Saving Context \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
//
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Categorypredicate,predicate])
//
//        request.predicate = compoundPredicate
        
        do{
            
            itemArray =  try context.fetch(request)
        }
        catch{
            print("Error Fethching data from contex \(error)")
        }
        tableView.reloadData()
        
    }
}


//MARK: - Search Bar Method
extension DoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "itemTitle CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "itemTitle", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

