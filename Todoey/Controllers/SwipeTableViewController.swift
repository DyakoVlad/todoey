//
//  TableViewController.swift
//  Todoey
//
//  Created by Ирина Дьякова on 15/01/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteItem(atRow: indexPath.row)
        }
        
        // customize the action appearance
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.image = UIImage(named: "delete-icon")
        deleteAction.backgroundColor = .clear
        deleteAction.textColor = UIColor.red
        deleteAction.font = .systemFont(ofSize: 13)
        deleteAction.transitionDelegate = ScaleTransition.default
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.buttonSpacing = 4
        options.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        
        return options
    }
    
    func deleteItem(atRow: Int) {
       //type your delete method here
    }

}
