import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
//    // This line gets the shared instance of the UIApplication, which represents the current running app.
//    --  let sharedApplication = UIApplication.shared
//
//    // This line gets the AppDelegate instance using the shared application instance.
//    --  let appDelegate = sharedApplication.delegate
//
//    // This line casts the delegate as an instance of the AppDelegate class.
//    // The "as!" operator is used for a forced downcast. It assumes that the delegate is an instance of AppDelegate, and if it's not, it will crash at runtime.
//    --  let appDelegateAsAppDelegate = appDelegate as! AppDelegate
//
//    // This line accesses the persistentContainer property of the AppDelegate.
//    // The persistent container is a part of Core Data, which is a framework used for data storage and management in iOS applications.
//    --  let persistentContainer = appDelegateAsAppDelegate.persistentContainer
//
//    // This line accesses the viewContext property of the persistent container.
//    // The view context is a managed object context that is used for interacting with the Core Data objects.
//    --  let context = persistentContainer.viewContext
//
//    // Now, 'context' can be used to perform Core Data operations like fetching, saving, and deleting objects.

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
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
            
            
            let newItem = Item(context: self.context)
            
            // create the title for the new file
            newItem.title = textField.text!
            // set done property of the new item to false because done is mandatory according to our entity
            newItem.done = false
            
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
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    // This function is responsible for loading items from Core Data into the itemArray.
    func loadItems() {
        // Create a fetch request for the "Item" entity.
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        do {
            // Attempt to fetch items from Core Data using the fetch request.
            // The fetched items will be stored in the itemArray.
            itemArray = try context.fetch(request)
        } catch {
            // If an error occurs during the fetch operation, print an error message.
            print("Error fetching data from context, \(error)")
        }
    }

}


