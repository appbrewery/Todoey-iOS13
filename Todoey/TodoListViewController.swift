import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = [ "Find hope" , "Buy thingys" , "Survive"  ]

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



}


