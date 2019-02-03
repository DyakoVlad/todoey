//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ирина Дьякова on 21/12/2018.
//  Copyright © 2018 Vlad Dyakov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError() }
        navBar.barTintColor = FlatWhite()
        navBar.tintColor = ContrastColorOf(FlatWhite(), returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(FlatWhite(), returnFlat: true)]
        searchBar.barTintColor = FlatWhite()
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let cellColor = UIColor(hexString: category.cellColour) else { fatalError() }
            cell.backgroundColor = cellColor
            cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
        } else {
            cell.textLabel?.text = "No categories added yet"
        }
        return cell
    }
    
    //MARK: Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsList", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: IBActions
    
    @IBAction func addNewCategoryButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            do {
                try self.realm.write {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.cellColour = RandomFlatColor().hexValue()
                    self.realm.add(newCategory)
                }
            } catch {
                print("Error with saving new category: \(error)")
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Enter new category here"
            textField = addTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func deleteItem(atRow: Int) {
        if let category = self.categories?[atRow] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error with deleting category: \(error)")
            }
        }
    }
    
}

extension CategoryTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == "" {
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            categories = categories?.filter("name CONTAINS[cd] %@", searchBar.text!)
            tableView.reloadData()
        }
    }
}
