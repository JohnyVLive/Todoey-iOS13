//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    //Creating a file path to the documents folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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
        self.saveItems()

        // Make every row animated selection
        tableView.deselectRow(at: indexPath, animated: true)
        

    }
    
    //MARK: - Add new Items
        
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //Creating and configure alert window
        let alert = UIAlertController(title: "Add new todoye item", message: "aaa", preferredStyle: .alert)
        //Configure action button and make the action to it
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen once the user clicks the Add Item button in the UIAlert
            if textField.text! != "" {
                
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)

                self.saveItems()
                
                self.tableView.reloadData()
            }
            
        }
        
        //Add the text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        //Add the action button to the alert
        alert.addAction(action)
        //Show the alert
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    
    // Function to save data to PList and reload Table View
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error. Encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //Function to load data from PList
    func loadItems(){
        do {
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error loading data from PList, \(error)")
        }
    }
    
}

