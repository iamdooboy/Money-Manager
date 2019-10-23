//
//  TransactionCell.swift
//  Money-Manager
//
//  Created by Duy Le on 7/26/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var catgoryLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    func configureCell(at indexPath: IndexPath){
        let dateObject = CoreDataManager.manager.fetchedResultsController.object(at: indexPath)
        
        guard let amount: Double = dateObject.transaction?.transactionAmount else { return }
        guard let category: String = dateObject.transaction?.transactionCategory else { return }
        guard let name: String = dateObject.transaction?.transactionName else { return }
        guard let type: String = dateObject.transaction?.transactionType else { return }
        
        let amountString = amount.convertDoubleToCurrency()
        
        self.amountLbl.text = amountString
        self.catgoryLbl.text = category
        self.nameLbl.text = name
        
        if(type == "Expense"){
            amountLbl.setExpensePrice()
        } else {
            amountLbl.setIncomePrice()
        }
    }
}
