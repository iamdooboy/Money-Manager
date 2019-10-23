//
//  ExpenseCell.swift
//  money-final
//
//  Created by Duy Le on 7/17/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    
    @IBOutlet weak var categorLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    func configureCell(at indexPath: IndexPath, category: [String], amount: [Double]){
        self.amountLbl.text = amount[indexPath.row].convertDoubleToCurrency()
        self.categorLbl.text = category[indexPath.row]
    }
    
}

