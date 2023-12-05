import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [ "Find hope" , "Buy thingys" , "Survive"  ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Set the text label of the cell to the corresponding item in the itemArray.
        cell.textLabel?.text = itemArray[indexPath.row]
        
        // Return the configured cell.
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    // This method is called when a cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected item from the array
        let selectedItem = itemArray[indexPath.row]
        
        // You can perform any action you want with the selected item
        // print("Selected Item: \(selectedItem)")
        
        // Get the selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            // Toggle the checkmark accessory type for the selected UITableViewCell.
            // If the current accessory type is .checkmark, it sets it to .none; otherwise, it sets it to .checkmark.
            // - The ternary operator (a ? b : c) is used here. If the condition (cell.accessoryType == .checkmark) is true,
            //   the value after the '?' (i.e., .none) is assigned; otherwise, the value after the ':' (i.e., .checkmark) is assigned.
            
            cell.accessoryType = (cell.accessoryType == .checkmark) ? .none : .checkmark
        }
        
        // Animation when the row is clicked
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)

        // Declare a variable to capture the text field
        var textField: UITextField?

        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // Use the captured text field to access the entered text and add it to the array
            self.itemArray.append(textField!.text!)
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


