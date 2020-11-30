//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Evgeniy Radchenko on 29.11.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Data Menipulation Methods
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            try self.categoryArray = context.fetch(request)
        } catch {
            print("Error fetching data from DB: \(error) ")
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        do {
            try self.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }

    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if alert.textFields?.isEmpty == false {
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categoryArray.append(newCategory)
                self.saveCategories()
            }
        }
        
        //Configure Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter category name"
            textField = alertTextField
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    

}
