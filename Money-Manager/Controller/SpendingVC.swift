//
//  SpendingVC.swift
//  Money-Manager
//
//  Created by Duy Le on 7/25/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SpendingVC: UIViewController {
    @IBOutlet weak var tableView: SelfSizedTableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    
    var segment: UISegmentedControl!
    var empty = [String]()
    var emptyAmount = [Double]()
    var incomeSum: Double = 0.0
    var expenseSum: Double = 0.0
    var balance: Double = 0.0
    var now = Foundation.Date()
    
    @IBAction func backwardBtnWasPressed(_ sender: Any) {
        dateLbl.rightTransition(0.2)
        let tabBar = tabBarController as! RaisedTabBarController
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! RaisedTabBarController
        
        switch (UIDevice().type) {
        case .iPhoneX:
            tableView.maxHeight = 440
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            tableView.maxHeight = 350
        case .iPod4, .iPod5, .iPhone4, .iPhone4S, .iPhone5, .iPhone5S, .iPhoneSE:
            tableView.maxHeight = 255
        default: //plus iPhones
            tableView.maxHeight = 415
        }
        
        //tableView.maxHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
        
        segment = UISegmentedControl(items: ["Week", "Month", "Year"])
        segment.sizeToFit()
        segment.tintColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
        segment.selectedSegmentIndex = tabBar.selectedSegment
//        segment.frame = CGRect(x: 0, y: 0, width: 250, height: 10)
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = tabBarController as! RaisedTabBarController
        let results = fetchObjects(predicate: tabBar.predicate!)
        
        setUpDictionary(results: results)
        
        setIncomeExpense()
        tableView.reloadData()

        switch tabBar.selectedSegment {
        case 0:
            segment.selectedSegmentIndex = 0
            dateLbl.text = "\(tabBar.currentStartWeek!) - \(tabBar.currentEndWeek!)"
        case 1:
            segment.selectedSegmentIndex = 1
            dateLbl.text = tabBar.currentMonth
        default:
            segment.selectedSegmentIndex = 2
            dateLbl.text = tabBar.currentYear
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetLabelsAndSums()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func changeSegment(sender: UISegmentedControl) {
        resetLabelsAndSums()
        now = Foundation.Date()
        let tabBar = tabBarController as! RaisedTabBarController
        tabBar.now = now
        
        switch sender.selectedSegmentIndex {
        case 0:
            let startWeek = now.startOfWeek
            let endWeek = now.endOfWeek
            
            tabBar.predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)", startWeek! as NSDate, endWeek! as NSDate)
            tabBar.currentStartWeek = startWeek?.convertDateToString()
            tabBar.currentEndWeek = endWeek?.convertDateToString()
            tabBar.selectedSegment = 0
            dateLbl.text = "\(tabBar.currentStartWeek!) - \(tabBar.currentEndWeek!)"
        case 1:
            let startMonth = now.startOfMonth
            let endMonth = now.endOfMonth
            
            tabBar.currentMonth = startMonth?.getMonthName()
            tabBar.predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)", startMonth! as NSDate, endMonth! as NSDate)
            tabBar.selectedSegment = 1
            dateLbl.text = tabBar.currentMonth
        default:
            let startOfYear = now.startOfYear
            let endOfYear = now.endOfYear
            
            tabBar.currentYear = startOfYear?.getYear()
            tabBar.predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)", startOfYear! as NSDate, endOfYear! as NSDate)
            tabBar.selectedSegment = 2
            dateLbl.text = tabBar.currentYear
        }
        
        CoreDataManager.manager.fetchedResultsController.fetchRequest.predicate = tabBar.predicate
        
        let results = fetchObjects(predicate: tabBar.predicate!)
        setUpDictionary(results: results)
        setIncomeExpense()
        tableView.reloadData()
    }
    
    func setUpDictionary(results:[Date]) {
        for order in results {
            
            let type = order.transaction?.transactionType
            let category = order.transaction?.transactionCategory
            let amount = order.transaction?.transactionAmount
            if (type == "Expense") {
                if (!empty.contains((category)!)) {
                    empty.append(category!)
                    emptyAmount.append(amount!)
                } else {
                    let i = empty.index(of: category!)
                    emptyAmount[i!] += amount!
                }
            } else if (order.transaction?.transactionType == "Income"){
                incomeSum += amount!
            }
        }
    }
    
    func fetch() {
        do {
            try CoreDataManager.manager.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
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
    
    func setIncomeExpense() {
        
        for values in emptyAmount{
            expenseSum += values
        }
        
        balance = incomeSum - expenseSum
        
        expenseLbl.text = expenseSum.convertDoubleToCurrency()
        incomeLbl.text = incomeSum.convertDoubleToCurrency()
        balanceLbl.text = balance.convertDoubleToCurrency()
        
    }
    
    func changeDate(_ sender: UIButton, currentDate: Foundation.Date, segment: Int, tab: RaisedTabBarController) {
        resetLabelsAndSums()
        
        var result: [Date]
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
        result = fetchObjects(predicate: tab.predicate!)
        
        setUpDictionary(results: result)
        setIncomeExpense()
        tableView.reloadData()
    }
    
    func resetLabelsAndSums() {
        empty.removeAll()
        emptyAmount.removeAll()
        incomeSum = 0.0
        expenseSum = 0.0
        balance = 0.0
    }

}

/*
 * UITableViewDelegate
 * UITableViewDataSource
 */
extension SpendingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "expense", for: indexPath) as? ExpenseCell else { return UITableViewCell() }
        cell.configureCell(at: indexPath, category: empty, amount: emptyAmount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
