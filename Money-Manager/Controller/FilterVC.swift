//
//  FilterVC.swift
//  Money-Manager
//
//  Created by Duy Le on 7/28/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit
import CoreData

class FilterVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var blurEffectView: UIVisualEffectView!
    var dimmedView: UIView!
    
    var expenseArray = [String]()
    var incomeArray = [String]()
    var type: TransactionType!
    
    var expenseSelectedIndex: IndexPath?
    var incomeSelectedIndex: IndexPath?
    
    static let manager = FilterVC()
    
    @IBAction func segmentWasPressed(_ sender: Any) {
        let tabBar = tabBarController as! RaisedTabBarController
        
        if (type == .expense) {
            type = .income
        } else {
            type = .expense
        }
        
        if let expense = expenseSelectedIndex {
            let cell = tableView.cellForRow(at: expense as IndexPath)
            cell?.accessoryType = .none
            cell?.textLabel?.textColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
            expenseSelectedIndex = nil
        }

        if let income = incomeSelectedIndex {
            let cell = tableView.cellForRow(at: income as IndexPath)
            cell?.accessoryType = .none
            cell?.textLabel?.textColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
            incomeSelectedIndex = nil
        }
        
        tabBar.categoryPredicate = nil
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        type = .expense
        segmentedControl.selectedSegmentIndex = 1
        
        tableView.delegate = self
        tableView.dataSource = self
        self.revealViewController().rightViewRevealWidth = 160
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let tabBar = tabBarController as! RaisedTabBarController
        
        if (tabBar.categoryPredicate == nil) {
            if let test = expenseSelectedIndex {
                let previousCell = tableView.cellForRow(at: test as IndexPath)
                previousCell?.accessoryType = .none
                previousCell?.textLabel?.textColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
            }
            
            if let test = incomeSelectedIndex {
                let previousCell = tableView.cellForRow(at: test as IndexPath)
                previousCell?.accessoryType = .none
                previousCell?.textLabel?.textColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
            }
            
            expenseSelectedIndex = nil
            incomeSelectedIndex = nil
        }
        
        let predicate = tabBar.predicate
        let results = fetchObjects(predicate: predicate!)
        setUpDictionary(results: results)
        
        tableView.reloadData()
        
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
        //self.revealViewController().filterView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        dimmedView = UIView()
        dimmedView.alpha = 0.25
        dimmedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dimmedView.frame = self.revealViewController().frontViewController.view.bounds
        self.revealViewController().frontViewController.view.addSubview(dimmedView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = tabBarController as! RaisedTabBarController
        
        super.viewWillDisappear(animated)
        dimmedView.removeFromSuperview()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
        
        if let temp = tabBar.categoryPredicate {
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [tabBar.predicate!, temp])
            CoreDataManager.manager.fetchedResultsController.fetchRequest.predicate = andPredicate
        } else {
            CoreDataManager.manager.fetchedResultsController.fetchRequest.predicate = tabBar.predicate
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func fetchObjects(predicate: NSPredicate) -> [Date] {
        
        var results = [Date]()
        
        let managedContext = CoreDataManager.manager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Date>(entityName: "Date")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        do {
            results = try managedContext.fetch(fetchRequest)
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
        
        return results
    }
    
    func setUpDictionary(results:[Date]) {
        
        expenseArray.removeAll()
        incomeArray.removeAll()
        
        for order in results {
            
            let type = order.transaction?.transactionType
            let category = order.transaction?.transactionCategory
            
            if (type == "Expense"){
                if (!expenseArray.contains(category!)){
                    expenseArray.append(category!)
                }
            } else {
                if (!incomeArray.contains(category!)){
                    incomeArray.append(category!)
                }
            }
        }
    }

}

extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return incomeArray.count
        case 1:
            return expenseArray.count
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = incomeArray[indexPath.row]
        case 1:
            cell.textLabel?.text = expenseArray[indexPath.row]
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabBar = tabBarController as! RaisedTabBarController
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
                tableView.deselectRow(at: indexPath, animated: true)
                tabBar.categoryPredicate = nil
                switch segmentedControl.selectedSegmentIndex{
                case 0:
                    incomeSelectedIndex = nil
                case 1:
                    expenseSelectedIndex = nil
                default:
                    break
                }
            } else {
                cell.accessoryType = .checkmark
                cell.tintColor = #colorLiteral(red: 0.3176470588, green: 0.5647058824, blue: 0.8470588235, alpha: 1)
                cell.textLabel?.textColor = #colorLiteral(red: 0.3176470588, green: 0.5647058824, blue: 0.8470588235, alpha: 1)
                if let test = expenseSelectedIndex {
                    let previousCell = tableView.cellForRow(at: test as IndexPath)
                    previousCell?.accessoryType = .none
                    previousCell?.textLabel?.textColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
                }
                
                switch segmentedControl.selectedSegmentIndex{
                case 0:
                    incomeSelectedIndex = indexPath
                case 1:
                    expenseSelectedIndex = indexPath
                default:
                    break
                }
                cell.setSelected(false, animated: false)
                tabBar.categoryPredicate = NSPredicate(format: "transaction.transactionCategory == %@", (cell.textLabel?.text)!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
        }
    }
    
}
