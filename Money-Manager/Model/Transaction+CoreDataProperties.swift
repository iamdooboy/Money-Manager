//
//  Transaction+CoreDataProperties.swift
//  Money-Manager
//
//  Created by Duy Le on 7/26/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var transactionName: String?
    @NSManaged public var transactionCategory: String?
    @NSManaged public var transactionAmount: Double
    @NSManaged public var transactionType: String?
    @NSManaged public var date: NSSet?

}

// MARK: Generated accessors for date
extension Transaction {

    @objc(addDateObject:)
    @NSManaged public func addToDate(_ value: Date)

    @objc(removeDateObject:)
    @NSManaged public func removeFromDate(_ value: Date)

    @objc(addDate:)
    @NSManaged public func addToDate(_ values: NSSet)

    @objc(removeDate:)
    @NSManaged public func removeFromDate(_ values: NSSet)

}
