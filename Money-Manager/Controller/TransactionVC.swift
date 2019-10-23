//
//  TransactionVC.swift
//  money-final
//
//  Created by Duy Le on 7/2/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit
import CoreData

class TransactionVC: UIViewController {

    @IBOutlet weak var filterBtn: UIBarButtonItem!
    
    var dateFormatter = DateFormatter()
    var now = Foundation.Date()
    
    var viewed: UIView?
    
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var segment: UISegmentedControl!
    
    @IBAction func backwardBtnWasPressed(_ sender: Any) {
        dateLbl.rightTransition(0.2)
        let tabBar = tabBarController as! RaisedTabBarController
        tabBar.categoryPredicate = nil
        changeDate(sender as! UIButton, currentDate: tabBar.now, segment: tabBar.selectedSegment, tab: tabBar)
        
        switch tabBar.selectedSegment {
        case 0:
            tabBar.now = tabBar.now.subtract(days: 7)
        case 1:
            tabBar.now = tabBar.now.subtract(months: 1)
        case 2:
            tabBar.now = tabBar.now.subtract(years: 1)
        default:
            break
        }
    }
    
    @IBAction func forwardBtnWasPressed(_ sender: Any) {
        dateLbl.leftTransition(0.2)
        let tabBar = tabBarController as! RaisedTabBarController
        tabBar.categoryPredicate = nil
        changeDate(sender as! UIButton, currentDate: tabBar.now, segment: tabBar.selectedSegment, tab: tabBar)
        
        switch tabBar.selectedSegment {
        case 0:
            tabBar.now = tabBar.now.add(days: 7)
        case 1:
            tabBar.now = tabBar.now.add(months: 1)
        case 2:
            tabBar.now = tabBar.now.add(years: 1)
        default:
            break
        }
    }

    @IBAction func editBtnWasPressed(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            self.navigationItem.leftBarButtonItem?.title = "Done"
            self.navigationItem.leftBarButtonItem?.style = .done
            
        } else {
            self.navigationItem.leftBarButtonItem?.title = "Edit"
            self.navigationItem.leftBarButtonItem?.style = .plain
        }
    }
    
    override func viewDidLoad() {
        if let revealController = self.revealViewController() {
            revealController.tapGestureRecognizer()
            //self.revealViewController().filterView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        navigationItem.leftBarButtonItem?.width = -10
        
        let tabBar = tabBarController as! RaisedTabBarController
        
        segment = UISegmentedControl(items: ["Week", "Month", "Year"])
        segment.tintColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
        segment.selectedSegmentIndex = tabBar.selectedSegment
        
        switch (UIDevice().type) {
        case .iPhoneX, .iPhone6, .iPhone6S, .iPhone7, .iPhone8: //big screen iPhones
            segment.frame = CGRect(x: 0, y: 0, width: 220, height: 10)
        case .iPod4, .iPod5, .iPhone4, .iPhone4S, .iPhone5, .iPhone5S, .iPhoneSE: //small screen iPhones
            segment.frame = CGRect(x: 0, y: 0, width: 180, height: 10)//se
        default: //plus iPhones
            segment.frame = CGRect(x: 0, y: 0, width: 260, height: 10)
        }
        
        segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "Avenir Next", size: 15)!], for: .normal)
        self.navigationItem.titleView = segment
        segment.addTarget(self, action: #selector(changeSegment(sender:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetch()
        tableView.reloadData()
        
        dateLbl.text = tabBar.currentMonth
        
        filterBtn.target = FilterVC()
        filterBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        
        self.extendedLayoutIncludesOpaqueBars = true //fix black bar above tab bar
    }
    
    @objc func loadList(){
        let tabBar = tabBarController as! RaisedTabBarController
        
        fetch()
        if let temp = tabBar.categoryPredicate {
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [tabBar.predicate!, temp])
            setIncomeExpense(predicate: andPredicate)
        } else {
            setIncomeExpense(predicate: tabBar.predicate!)
        }
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        let tabBar = tabBarController as! RaisedTabBarController
        
        setIncomeExpense(predicate: tabBar.predicate!)
        
        switch tabBar.selectedSegment {
        case 0:
            segment.selectedSegmentIndex = 0 //week
            dateLbl.text = "\(tabBar.currentStartWeek!) - \(tabBar.currentEndWeek!)"
        case 1:
            segment.selectedSegmentIndex = 1 //month
            dateLbl.text = tabBar.currentMonth
        default:
            segment.selectedSegmentIndex = 2 //year
            dateLbl.text = tabBar.currentYear
        }
    
    }
    
    func fetch() {
        CoreDataManager.manager.fetchedResultsController.delegate = self
        do{
            try CoreDataManager.manager.fetchedResultsController.performFetch()
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTransactionVC" {
            if let destination = segue.destination as? AddTransactionVC {
                if let item = sender as? Date {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    @objc func changeSegment(sender: UISegmentedControl) {
        now = Foundation.Date()
        let current = Foundation.Date()
        let tabBar = tabBarController as! RaisedTabBarController
        tabBar.now = now
        switch sender.selectedSegmentIndex {
        case 0:
            let startWeek = current.startOfWeek
            let endWeek = current.endOfWeek
            tabBar.currentStartWeek = startWeek?.convertDateToString()
            tabBar.currentEndWeek = endWeek?.convertDateToString()
            dateLbl.text = "\(tabBar.currentStartWeek!) - \(tabBar.currentEndWeek!)"
            
            tabBar.predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)", startWeek! as NSDate, endWeek! as NSDate)
            tabBar.selectedSegment = 0
            
        case 1:
            let startMonth = current.startOfMonth
            let endMonth = current.endOfMonth
            tabBar.currentMonth = startMonth?.getMonthName()
            dateLbl.text = tabBar.currentMonth
            
            tabBar.predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)", startMonth! as NSDate, endMonth! as NSDate)
            tabBar.selectedSegment = 1
            
        default:
            let startOfYear = current.startOfYear
            let endOfYear = current.endOfYear
            tabBar.currentYear = startOfYear?.getYear()
            dateLbl.text = tabBar.currentYear
            
            tabBar.predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)", startOfYear! as NSDate, endOfYear! as NSDate)
            tabBar.selectedSegment = 2
            
        }
        
        if let categoryPredicate = tabBar.categoryPredicate {
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [tabBar.predicate!, categoryPredicate])
            CoreDataManager.manager.fetchedResultsController.fetchRequest.predicate = andPredicate
        } else {
            CoreDataManager.manager.fetchedResultsController.fetchRequest.predicate = tabBar.predicate
        }
        
        fetch()
        tableView.reloadData()
        setIncomeExpense(predicate: tabBar.predicate!)
        
    }
    
    func setIncomeExpense(predicate: NSPredicate) {
        let managedContext = CoreDataManager.manager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Date>(entityName: "Date")
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            var expenseSum: Double = 0.0
            var incomeSum: Double = 0.0
            var balance: Double = 0.0
            
            for order in results {
                if (order.transaction?.transactionType == "Expense"){
                    let xP = order.transaction?.transactionAmount
                    expenseSum += xP!
                } else if (order.transaction?.transactionType == "Income"){
                    let iC = order.transaction?.transactionAmount
                    incomeSum += iC!
                }
            }
            
            balance = incomeSum - expenseSum
            
            incomeLbl.text = incomeSum.convertDoubleToCurrency()
            expenseLbl.text = expenseSum.convertDoubleToCurrency()
            balanceLbl.text = balance.convertDoubleToCurrency()
        } catch {
            debugPrint("Error: \(error.localizedDescription)")
        }
    }
    
    func changeDate(_ sender: UIButton, currentDate: Foundation.Date, segment: Int, tab: RaisedTabBarController) {
        var start: Foundation.Date
        var end: Foundation.Date
        var nextStart: Foundation.Date
        var nextEnd: Foundation.Date
        
        start = currentDate.startOfMonth!
        end = currentDate.endOfMonth!
        nextStart = start.add(months: 1)
        nextEnd = end.add(months: 1)
        
        switch segment {
        case 0:
            start = currentDate.startOfWeek!
            end = currentDate.endOfWeek!
            if(sender == forwardBtn) {
                nextStart = start.add(days: 7)
                nextEnd = end.add(days: 7)
            } else {
                nextStart = start.subtract(days: 7)
                nextEnd = end.subtract(days: 7)
            }
            
            let nextStartString = nextStart.convertDateToString()
            let nextEndString = nextEnd.convertDateToString()
            
            tab.currentStartWeek = nextStartString
            tab.currentEndWeek = nextEndString
            
            if (nextEnd.getYear() != Foundation.Date().getYear()) {
                dateLbl.text = "\(tab.currentStartWeek!) - \(tab.currentEndWeek!), '\(nextStart.getYearInShortFormat())"
            } else {
                dateLbl.text = "\(tab.currentStartWeek!) - \(tab.currentEndWeek!)"
            }
        case 1:
            start = currentDate.startOfMonth!
            end = currentDate.endOfMonth!
            if (sender == forwardBtn) {
                nextStart = start.add(months: 1)
                nextEnd = end.add(months: 1)
            } else {
                nextStart = start.subtract(months: 1)
                nextEnd = end.subtract(months: 1)
            }
            
            tab.currentMonth = nextStart.getMonthName()
            
            if (nextStart.getYear() != Foundation.Date().getYear()) {
                dateLbl.text = tab.currentMonth! + " " + (nextStart.getYear())
            } else {
                dateLbl.text = tab.currentMonth
            }
        case 2:
            start = currentDate.startOfYear!
            end = currentDate.endOfYear!
            
            if(sender == forwardBtn) {
                nextStart = start.add(years: 1)
                nextEnd = end.add(years: 1)
            } else {
                nextStart = start.subtract(years: 1)
                nextEnd = end.subtract(years: 1)
            }
            
            tab.currentYear = nextStart.getYear()
            
            dateLbl.text = tab.currentYear
        default:
            break
        }
        
        tab.predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)", nextStart as NSDate, nextEnd as NSDate)
        CoreDataManager.manager.fetchedResultsController.fetchRequest.predicate = tab.predicate
        fetch()
        tableView.reloadData()
        setIncomeExpense(predicate: tab.predicate!)
    }

}

/*
 * UITableViewDelegate
 * UITableViewDataSource
 */
extension TransactionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let dateSections = CoreDataManager.manager.fetchedResultsController.sections {
            if (dateSections.count == 0){
                tableView.isHidden = true
            } else {
                tableView.isHidden = false
            }
            return dateSections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = CoreDataManager.manager.fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TransactionCell else { return UITableViewCell() }
        
        cell.configureCell(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let sections = CoreDataManager.manager.fetchedResultsController.sections {
            
            let tabBar = tabBarController as! RaisedTabBarController
            let currentSection = sections[section]
            
            let date = currentSection.name.formatDateString(separation: " ")[0]
            let format = date.formatDateString(separation: "-")
            
            let month = format[1].getMonth()
            let day = format[2]
            let year = format[0]
            
            let str = "\(year)-\(month)-\(day)"
            let weekday = str.getDayNameBy()
            
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.8788938201, green: 0.8788938201, blue: 0.8788938201, alpha: 1)
            
            let label = UILabel()
            switch tabBar.selectedSegment {
            case 0:
                label.text = "\(weekday), \(month) \(day)"
            case 1:
                label.text = month + " " + day
            default:
                label.text = month + " " + day + ", " + year
            }
            label.frame = CGRect(x: 10, y: 0, width: 400, height: 25)
            label.font = UIFont(name: "Avenir Next", size: 14)
            label.textColor = #colorLiteral(red: 0.4714412015, green: 0.5008932315, blue: 0.5323003757, alpha: 1)
            
            view.addSubview(label)
            return view
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let tabBar = tabBarController as! RaisedTabBarController
        
        if editingStyle == .delete {
            let date = CoreDataManager.manager.fetchedResultsController.object(at: indexPath)
            date.managedObjectContext?.delete(date)
            do {
                try date.managedObjectContext?.save()
                setIncomeExpense(predicate: tabBar.predicate!)
            } catch {
                print(error)
            }
        }
        
        if (tableView.isHidden) {
            tabBar.categoryPredicate = nil
            CoreDataManager.manager.fetchedResultsController.fetchRequest.predicate = tabBar.predicate
            fetch()
            tableView.reloadData()
            setIncomeExpense(predicate: tabBar.predicate!)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = CoreDataManager.manager.fetchedResultsController.object(at: indexPath)
        
        performSegue(withIdentifier: "AddTransactionVC", sender: person)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

/*
 * NSFetchedResultsControllerDelegate
 */
extension TransactionVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? TransactionCell {
                cell.configureCell(at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break;
        }
    }
}

