//
//  Date+CoreDataProperties.swift
//  Money-Manager
//
//  Created by Duy Le on 7/26/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//
//

import Foundation
import CoreData


extension Date {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Date> {
        return NSFetchRequest<Date>(entityName: "Date")
    }

    @NSManaged public var transactionDate: NSDate?
    @NSManaged public var transaction: Transaction?

}
