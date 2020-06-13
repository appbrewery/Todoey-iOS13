//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var tasks: [Task] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }
    
    // MARK: - IBAction

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: nil, message: "Add a task", preferredStyle: .alert)
        alertVC.addTextField { $0.placeholder = "Write your task here" }
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            guard let task = alertVC.textFields?.first?.text,
                !task.isEmpty else { return }
            self.tasks.append(Task(taskName: task))
            self.saveTasks()

        }
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    // MARK: - Methods

    // must add do / catch to manage error and unwrap dataFilePath
    private func saveTasks() {
        let encoder = PropertyListEncoder()

        let data = try? encoder.encode(tasks)
        try? data?.write(to: dataFilePath!)
    }

    // must add do / catch to manage error and unwrap dataFilePath
    private func loadItems() {
        guard let data = try? Data(contentsOf: dataFilePath!) else { return }
        let decoder = PropertyListDecoder()
        guard let decodedData = try? decoder.decode([Task].self, from: data) else { return }
        tasks = decodedData
    }

    // MARK: - TableView Datasource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].taskName

        cell.accessoryType = tasks[indexPath.row].taskIsDone ? .checkmark : .none

        return cell
    }

    // MARK: - Tableview Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].taskIsDone.toggle()
        saveTasks()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

