//
//  MasterViewController.swift
//  Windows
//
//  Created by B Gay on 8/1/19.
//  Copyright © 2019 B Gay. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // The sections for our table view we only have one so we can just call it main
    enum Section {
        case main
    }
    
    // The data source for a table view. With sections of object type Section and rows with object type Date
    lazy var dataSource = UITableViewDiffableDataSource<Section, Date>(tableView: self.tableView) { (tableView, indexPath, date) -> UITableViewCell? in

        // Dequeue a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Populate the text label with the date description
        cell.textLabel?.text = date.description
        
        // Return the cell
        return cell
    }
    
    lazy var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Date> =  {
        
        // Create a new snapshote
        let currentSnapshot = NSDiffableDataSourceSnapshot<Section, Date>()
        
        // Add the only section to the snapshot
        currentSnapshot.appendSections([.main])
        
        // Add all of the dates from DatesController to that  section
        currentSnapshot.appendItems(DatesController.shared.dates, toSection: .main)
        
        // Return the snapshot
        return currentSnapshot
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add the edit button to the left bar button item
        navigationItem.leftBarButtonItem = editButtonItem

        // Init the add button and add to the right bar button item
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        // Add MasterViewController as an observer to the DatesController dates array and perform the following whenever there's a change
        DatesController.shared.addOnUpdate { [weak self] in
            
            // Use weak self to prevent retain cycles and check if self is still around for this update
            guard let strongSelf = self else { return }
            
            // Create a new snapshot for the updated array
            strongSelf.currentSnapshot = NSDiffableDataSourceSnapshot<Section, Date>()
            
            // Still only have the one section
            strongSelf.currentSnapshot.appendSections([.main])
            
            // Add the updated array of dates to the snapshot
            strongSelf.currentSnapshot.appendItems(DatesController.shared.dates, toSection: .main)
            
            // Apply the new snapshot, animating the changes
            strongSelf.dataSource.apply(strongSelf.currentSnapshot, animatingDifferences: true)
        }
        
        // Use whatever animation the system deems best for changes
        dataSource.defaultRowAnimation = .automatic
        
        // Assign our UITableViewDiffableDataSource as the dataSource of our table view
        tableView.dataSource = dataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        DatesController.shared.dates.insert(Date(), at: 0)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = DatesController.shared.dates[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    // The template uses a deprecated way of deleting replace with trailingSwipeActionsConfigurationForRowAt
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create a delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            DatesController.shared.dates.remove(at: indexPath.row)
        }
        
        // Return a configuration with the delete action
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

