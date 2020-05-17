//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 佐藤万莉 on 2020/05/14.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    var category: String = ""
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = categoryArray[indexPath.row].name!
        performSegue(withIdentifier: "goToItems", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let todoVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                todoVC.selectedCategory = categoryArray[indexPath.row]
            }
        }
    }
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil) 
        
        
//        MARK: - Tableview Detasource Methods
        
//        MARK: - Tableview Delegate Methods
        
//        MARK: - Tableview Data Manipulation Methods
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
}


