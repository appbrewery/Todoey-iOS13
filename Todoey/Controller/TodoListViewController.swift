import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //    // gets the shared instance of the UIApplication, which represents the current running app.
    //    --  let sharedApplication = UIApplication.shared
    //
    //    // gets the AppDelegate instance using the shared application instance.
    //    --  let appDelegate = sharedApplication.delegate
    //
    //    // casts the delegate as an instance of the AppDelegate class.
    //    // The "as!" operator is used for a forced downcast. It assumes that the delegate is an instance of AppDelegate, and if it's not, it will crash at runtime.
    //    --  let appDelegateAsAppDelegate = appDelegate as! AppDelegate
    //
    //    // accesses the persistentContainer property of the AppDelegate.
    //    // The persistent container is a part of Core Data, which is a framework used for data storage and management in iOS applications.
    //    --  let persistentContainer = appDelegateAsAppDelegate.persistentContainer
    //
    //    // accesses the viewContext property of the persistent container.
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
        
        ////////////CODE TO DELETE INSTEAD OF CHECK
        //        // This line of code deletes the item at the specified indexPath.row from the Core Data context.
        //        context.delete(itemArray[indexPath.row])
        //
        //        // This line of code removes the same item from the local itemArray.
        //        itemArray.remove(at: indexPath.row)
        
        
        // call to the function saveItems to pass from the context to the real database
        saveItems()
        
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
            // property of the category parent of the item
            newItem.categoryName = self.selectedCategory
            
            // Use the captured text field to access the entered text and add it to the array
            self.itemArray.append(newItem)
            
            // call to the function saveItems
            self.saveItems()
            
            
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
    // this function is to load items based on a given fetch request. The flexibility is provided by allowing you to either provide a custom fetch request (with:) or use the default one (Item.fetchRequest()).
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        let predicate = NSPredicate(format: "categoryName.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = predicate // correct predicate 
        
        do {
            // Attempt to fetch items from Core Data using the fetch request.
            // The fetched items will be stored in the itemArray.
            itemArray = try context.fetch(request)
        } catch {
            // If an error occurs during the fetch operation, print an error message.
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
}

// MARK: - Extension for the SearchBar Method
extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? true {
            // If the search bar text is empty, load all items and resign first responder
            loadItems()
            
            // send the request to backfround thread to avoud app crashes
            DispatchQueue.main.async {
                // Hide the keyboard when the search bar is empty
                searchBar.resignFirstResponder()
            }
        } else {
            // If there is text in the search bar, filter and load items based on the search text
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            if let text = searchBar.text {
                // Set the predicate of the fetch request to filter results based on a condition.
                // In this case, the condition is defined using NSPredicate.
                request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
                
                // Set the sort descriptors for the fetch request to define the order of fetched results.
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
                // calling loadItem with the new request value
                loadItems(with: request)
            }
        }
    }

    
}



