import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Items]()
    
    // Get the URL of the document directory for the current app's sandboxed environment
    //        FileManager.default: The default file manager for the app.
    //        urls(for:in:): A method to get URLs for specified directories in a specified domain.
    //        .documentDirectory: Indicates the document directory, a location where you can store user-generated content.
    //        .userDomainMask: Specifies the user's home directory as the domain for the search.
    //        .first: Retrieves the first URL from the array of URLs returned by urls(for:in:).
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
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
        
        // call to the function saveItems
        self.saveItems()
        
        // reload the table
        tableView.reloadData()
        
        // Animation when the row is clicked
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Declare a variable to capture the text field
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            // create new item
            let newItem = Items(title: "Your Title Here", done: false)
            
            // create the title for the new file
            newItem.title = textField.text!
            
            // Use the captured text field to access the entered text and add it to the array
            self.itemArray.append(newItem)
            
            // call to the function saveItems
            self.saveItems()
            
            // reload the table
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
    
    
    // MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        // Create an instance of PropertyListEncoder, which is responsible for encoding property lists.
        let encoder = PropertyListEncoder()
        
        do {
            // Attempt to encode the array of items (self.itemArray).
            let data = try encoder.encode(itemArray)
            
            // Try to write the encoded data to the file specified by self.dataFilePath.
            try data.write(to: dataFilePath!)
            
        } catch {
            // If an error occurs during encoding or writing to the file, catch the error and print a descriptive message.
            print("Error encoding item array, \(error)")
        }
        
    }
    
    func loadItems(){
        
        // access the data from the dataFilePath
        if let data = try? Data(contentsOf: dataFilePath!) {
            // create the decoder
            let decoder = PropertyListDecoder()
            do {
                // decode the data
                itemArray = try decoder.decode([Items].self, from: data)
            } catch {
                print("Error decoding the data, \(error)")
            }
        }
    }
}


