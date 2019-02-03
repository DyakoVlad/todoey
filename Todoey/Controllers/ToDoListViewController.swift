//
//  ViewController.swift
//  Todoey
//
//  Created by Ирина Дьякова on 03/12/2018.
//  Copyright © 2018 Vlad Dyakov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var items: Results<Item>?
    var selectCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectCategory?.name
        guard let cellColor = selectCategory?.cellColour else { fatalError() }
        changeNavColor(withHexColor: cellColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        title = "Todoey"
        changeNavColor(withHexColor: FlatWhite().hexValue())
    }
    
    func changeNavColor(withHexColor colorHex: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError() }
        guard let navBarColor = HexColor(colorHex) else { fatalError() }
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }

    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
            guard let cellColor = HexColor(selectCategory!.cellColour) else { fatalError() }
            guard let currentCellColor = cellColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) else { fatalError() }
            cell.backgroundColor = currentCellColor
            cell.textLabel?.textColor = ContrastColorOf(currentCellColor, returnFlat: true)
            cell.tintColor = ContrastColorOf(currentCellColor, returnFlat: true)
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    //MARK: Tableview Delegate Methogs
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error with updating isDone property of Item: \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: IBActions
    
    @IBAction func addNewItemButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error with saving new item: \(error)")
                }
                self.tableView.reloadData()
            }
            
        }
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Enter new item here"
            textField = addTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {
        items = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func deleteItem(atRow: Int) {
        if let item = self.items?[atRow] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error with deleting category: \(error)")
            }
        }
    }
    
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == "" {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
        }
    }
}
