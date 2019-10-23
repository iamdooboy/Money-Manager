//
//  StringExt.swift
//  Money-Manager
//
//  Created by Duy Le on 7/26/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    //convert string to date
    func convertToDate() -> Foundation.Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateObject = dateFormatter.date(from: self)
        return dateObject!
    }
    
    //convert currency String to Double
    func convertCurrencyToDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    func getMonth() -> String {
        switch self {
        case "01":
            return "Jan"
        case "02":
            return "Feb"
        case "03":
            return "Mar"
        case "04":
            return "Apr"
        case "05":
            return "May"
        case "06":
            return "Jun"
        case "07":
            return "Jul"
        case "08":
            return "Aug"
        case "09":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        default:
            return "Dec"
        }
    }
    
    func formatDateString(separation: String) -> [String] {
        let str = self.components(separatedBy: separation)
        return str
    }

    func getDayNameBy() -> String {
        let df  = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: self)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
}
