//
//  AddTransactionVC.swift
//  Money-Manager
//
//  Created by Duy Le on 7/26/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class AddTransactionVC: UIViewController, PassDataBack {
    
    func returnDataProtocol(data: String) {
        categoryTxtField.text = data
    }
    
    @IBOutlet weak var expenseBtn: UIButton!
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var noteTxtField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var activeTextField: UITextField!
    var itemToEdit: Date?
    var transactionType: TransactionType!
    
    let picker = UIDatePicker()
    
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        dateTxtField.delegate = self
        categoryTxtField.delegate = self
        noteTxtField.delegate = self
        amountTxtField.delegate = self
        
        setCornerRadius()
        expenseIsSelected()
        createDatePicker()
        
        amountTxtField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        if itemToEdit != nil {
            loadItemData()
        }
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize  = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        let editingTextFieldY: CGFloat! = self.activeTextField?.frame.origin.y

        if self.view.frame.origin.y >= 0 {
            if editingTextFieldY > keyboardY - 60 {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 45)), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardDidHide(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { self.view.frame = CGRect(
            x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    @IBAction func expenseBtnPressed(_ sender: Any) {
        expenseIsSelected()
        categoryTxtField.text = ""
        
    }
    
    @IBAction func incomeBtnPressed(_ sender: Any) {
        incomeIsSelected()
        categoryTxtField.text = ""
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if itemToEdit == nil {
            guard let amountString = amountTxtField.text, amountString != "" else {
                return
            }
            
            guard let category = categoryTxtField.text, category != "" else {
                return
            }
            
            guard let dateString = dateTxtField.text, dateString != "" else {
                return
            }
            
            guard let note = noteTxtField.text, note != "" else {
                return
            }
            
            let amount = amountString.convertCurrencyToDouble()
            let date = dateString.convertToDate()
            
            CoreDataManager.manager.initData(type: transactionType.rawValue, date: date, amount: amount!, category: category, name: note)
            CoreDataManager.manager.insertTransaction()
        } else {
            
            let amount =  amountTxtField.text!.convertCurrencyToDouble()
            let note = noteTxtField.text!
            let type = transactionType.rawValue
            let category = categoryTxtField.text!
            let date = dateTxtField.text!.convertToDate()
            
            CoreDataManager.manager.updateTransaction(name: note, type: type, amount: amount!, category: category, date: date, item: itemToEdit!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func createDatePicker(){
        let currentDateTime = Foundation.Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        dateTxtField.text = dateFormatter.string(from: currentDateTime)
        
        picker.addTarget(self, action: #selector(selectingInDate), for: UIControlEvents.valueChanged)
        
        dateTxtField.inputView = picker
        picker.datePickerMode = .date
    }
    
    @objc func selectingInDate(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateTxtField.text = formatter.string(from: sender.date)
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let amount = item.transaction?.transactionAmount
            
            amountTxtField.text = amount?.convertDoubleToCurrency()
            categoryTxtField.text = item.transaction?.value(forKey: "transactionCategory") as? String
            noteTxtField.text = item.transaction?.value(forKey: "transactionName") as? String
            dateTxtField.text = dateFormatter.string(from: item.value(forKey: "transactionDate") as! Foundation.Date)
            
            picker.date = item.value(forKey: "transactionDate") as! Foundation.Date
            
            if (item.transaction?.transactionType == "Expense") {
                transactionType = .expense
                expenseBtn.setSelectedColor()
                incomeBtn.setDeselectedColor()
            } else if (item.transaction?.transactionType == "Income") {
                transactionType = .income
                incomeBtn.setSelectedColor()
                expenseBtn.setDeselectedColor()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func expenseIsSelected() {
        transactionType = .expense
        expenseBtn.setSelectedColor()
        incomeBtn.setDeselectedColor()
    }
    
    func incomeIsSelected() {
        transactionType = .income
        incomeBtn.setSelectedColor()
        expenseBtn.setDeselectedColor()
    }
    
    func setCornerRadius(){
        incomeBtn.layer.cornerRadius = 5
        expenseBtn.layer.cornerRadius = 5
        cancelBtn.layer.cornerRadius = 5
        saveBtn.layer.cornerRadius = 5
    }

}

/*
 * UITextFieldDelegate
 */

extension AddTransactionVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == categoryTxtField){
            
            amountTxtField.resignFirstResponder()
            
            if(transactionType == .expense){
                guard let categoryVC = storyboard?.instantiateViewController(withIdentifier: "ExpenseVC") as? ExpenseVC else { return true }
                
                self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: categoryVC)
                
                categoryVC.delegate = self
                categoryVC.modalPresentationStyle = UIModalPresentationStyle.custom
                categoryVC.transitioningDelegate = self.halfModalTransitioningDelegate
                present(categoryVC, animated: true, completion: nil)
                
                return false
            } else if (transactionType == .income) {
                guard let categoryVC = storyboard?.instantiateViewController(withIdentifier: "IncomeVC") as? IncomeVC else { return true }
                
                self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: categoryVC)
                
                categoryVC.delegate = self
                categoryVC.modalPresentationStyle = UIModalPresentationStyle.custom
                categoryVC.transitioningDelegate = self.halfModalTransitioningDelegate
                present(categoryVC, animated: true, completion: nil)
                
                return false
            }
            
        }
        return true
    }
    
}

extension AddTransactionVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class HalfSizePresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            
            return CGRect(x: 0, y: theView.bounds.height/2 + theView.bounds.height/6, width: theView.bounds.width, height: theView.bounds.height)
        }
    }
}
