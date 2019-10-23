//
//  CoreDataManager.swift
//  money-final
//
//  Created by Duy Le on 7/3/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSManagedObject {
    
    static let manager = CoreDataManager()
    
    var date: Foundation.Date?
    var type: String?
    var category: String?
    var amount: Double?
    var name: String?
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Money_Manager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func initData(type: String, date: Foundation.Date, amount: Double, category: String, name: String) {
        self.date = date
        self.type = type
        self.category = category
        self.amount = amount
        self.name = name
        
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Date> = {
        
        // Set calendar and date
        let calendar = Calendar.current
        let date = calendar.date(byAdding: DateComponents(day: 0), to: Foundation.Date())!
        
        // Get range of days in month
        let range = calendar.range(of: .day, in: .month, for: date)! // Range(1..<32)
        
        // Get first day of month
        var firstDayComponents = calendar.dateComponents([.year, .month], from: date)
        firstDayComponents.day = range.lowerBound
        let firstDay = calendar.date(from: firstDayComponents)! as NSDate
        
        // Get last day of month
        var lastDayComponents = calendar.dateComponents([.year, .month], from: date)
        lastDayComponents.day = range.upperBound - 1
        let lastDay = calendar.date(from: lastDayComponents)! as NSDate
        
        let predicate = NSPredicate(format:"(transactionDate >= %@) AND (transactionDate <= %@)",firstDay,lastDay)
        
        let managedContext = CoreDataManager.manager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Date>(entityName: "Date")
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "transactionDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController<Date>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "transactionDate", cacheName: nil)
        
        return fetchedResultsController
    }()
    
    func insertTransaction() {
        
        let managedContext = CoreDataManager.manager.persistentContainer.viewContext
        
        let transactionObject = Transaction(context: managedContext)
        let dateObject = Date(context: managedContext)
        
        transactionObject.transactionType = self.type!
        transactionObject.transactionAmount = self.amount!
        transactionObject.transactionCategory = self.category!
        transactionObject.transactionName = self.name!
        
        dateObject.transactionDate = self.date! as NSDate
        
        transactionObject.addToDate(dateObject)
        
        do {
            try managedContext.save()
            print("Successfully saved transaction and date")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateTransaction(name: String, type: String, amount: Double, category: String, date: Foundation.Date, item: Date) {
        let managedContext = CoreDataManager.manager.persistentContainer.viewContext
        
        item.transaction?.setValue(name, forKey: "transactionName")
        item.transaction?.setValue(type, forKey: "transactionType")
        item.transaction?.setValue(amount, forKey: "transactionAmount")
        item.transaction?.setValue(category, forKey: "transactionCategory")
        item.setValue(date, forKey: "transactionDate")
        
        do {
            try managedContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
}

