import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Items]()
    
    // var to keep the data entered by the user
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // items of the table
        let newItem = Items()
        newItem.title = "Find hope"
        itemArray.append(newItem)
        
        let newItem2 = Items()
        newItem2.title = "Save the world"
        itemArray.append(newItem2)
        
        let newItem3 = Items()
        newItem3.title = "Buy peanuts"
    }
    
    // MARK: - Tableview Datasource Methods
    
    // This method is called to determine the number of rows in the specified section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // The number of rows is equal to the count of items in the itemArray.
        return itemArray.count
    }
    
    // This method is called to provide a cell for a specific row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a reusable cell with the identifier "ToDoItemCell" for the specified indexPath.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // define current item
        let item = itemArray[indexPath.row]
        
        // Set the text label of the cell to the corresponding item in the itemArray defined above
        cell.textLabel?.text = item.title
        
        // terniary operator to change the done 
        cell.accessoryType = item.done ? .checkmark : .none
        
        // Return the configured cell.
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    // This method is called when a cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Toggle the 'done' property of the item at the specified index path row
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // reload the table
        tableView.reloadData()
        
        // Animation when the row is clicked
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        

        // Declare a variable to capture the text field
        var textField: UITextField?

        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            // create new item
            let newItem = Items()
            
            // create the title for the new file
            newItem.title = textField!.text!
            
            // Use the captured text field to access the entered text and add it to the array
            self.itemArray.append(newItem)
            
            // keep the data entered by the user
            self.defaults.set(self.itemArray, forKey: "TodoListAray")
            
            //reload the table with the new entry
            self.tableView.reloadData()
        }
        
        // Capture the textfield when it's added
        alert.addTextField { (alertTextField) in
            
            // Set a placeholder text for the text field
            alertTextField.placeholder = "Create new item"
            
            // Capture the reference to the text field for later use
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


