//
//  ViewController.swift
//  Todoey
//
//  Created by Luke McCarthy on 28/01/19.
//  Copyright © 2019 Luke McCarthy. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ToDoListViewController: SwipeViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Click the + to add an item"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error marking item as done, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    } 
                } catch {
                    print("Error writing items \(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
   
    // MARK: - Delete from Swipe
    
    override func updateModel(at indexpath: IndexPath) {
        
        if let itemToDelete = self.todoItems?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("error deleting item \(error)")
            }
        }
    }
}



//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
