//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    //Creating a file path to the documents folder
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Creating an objet of Context in DataModel
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems()
        
    }
    
    //MARK: - TableView Datasource Methods
    
    // Set amount of cells in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    // Set the data for every cell and return the cell to the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Set a property to the cell from "done" parameter of the object.
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // If cell touched, change an accessory type of the object
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //Save data after every change
        saveItems()

        // Make every row animated selection
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new Items
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creating and configure alert window
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        //Configure Add button and set things to do when press
        let saveAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen once the user clicks the Add Item button in the UIAlert
            if textField.text! != "" {
                
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                self.itemArray.append(newItem)

                self.saveItems()
                
                self.tableView.reloadData()
            }
            
        }
        
        //Configure Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        //Add the text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        //Add the action buttons to the alert
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        //Show the alert
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    
    //Function to save data from context to database (DataCore)
    func saveItems(){
        
        do {
            try self.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //Function to load data to array from database (DataCore) with default value  = Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            try itemArray = context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    

    
}

//MARK: - SearchBar methods
extension TodoListViewController: UISearchBarDelegate{
    
    //Hides keyboard and focuses to main window
    func closeKeyboard(_ searchBar: UISearchBar){
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Create a search predicate for request from CoreData
        //[cd] means Case Diacritic (Insensitive) search
        if searchBar.text != "" {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate.init(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
            
            closeKeyboard(searchBar)

        } else{
            //Show all records if no search entry
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = nil
            loadItems(with: request)
            
            closeKeyboard(searchBar)
        }
    }
    
    //Show all records if no search entry
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            closeKeyboard(searchBar)
        }
    }
    
}

