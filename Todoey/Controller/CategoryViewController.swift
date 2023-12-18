import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
            
        } catch {
            print("Error saving category, \(error)")
        }
        self.tableView.reloadData()
    }
    // this function is to load items based on a given fetch request. The flexibility is provided by allowing you to either provide a custom fetch request (with:) or use the default one (Item.fetchRequest()).
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            // Attempt to fetch items from Core Data using the fetch request.
            // The fetched items will be stored in the itemArray.
            categories = try context.fetch(request)
        } catch {
            // If an error occurs during the fetch operation, print an error message.
            print("Error loading categories, \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Declare a variable to capture the text field
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            // create the title for the new file
            newCategory.name = textField.text!
            
            // Use the captured text field to access the entered text and add it to the array
            self.categories.append(newCategory)
            
            // call to the function saveItems
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            
            // Set a placeholder text for the text field
            alertTextField.placeholder = "Create new category"
            
            // Capture the reference to the text field for later use
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
    // MARK: - TableView Delegate Methods - (do it later)
    

