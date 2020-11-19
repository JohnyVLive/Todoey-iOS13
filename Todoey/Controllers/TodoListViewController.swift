//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
//        ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Loads up the data from the User Defaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
//            itemArray = items
//        }
        let newItem1 = Item()
        newItem1.title = "Find Mike"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        newItem2.done = true
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        
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

        // Make every row animated selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Reload Table View after every change
        tableView.reloadData()
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

                self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
}

