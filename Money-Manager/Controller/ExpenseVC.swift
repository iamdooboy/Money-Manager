//
//  ExpenseVC.swift
//  Money-Manager
//
//  Created by Duy Le on 7/27/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class ExpenseVC: UIViewController {

    var row1 = [UIButton]()
    var row2 = [UIButton]()
    var row3 = [UIButton]()
    var row4 = [UIButton]()
    
    var stackview1 : UIStackView!
    var stackview2 : UIStackView!
    var stackview3 : UIStackView!
    var stackview4 : UIStackView!
    
    var stackViewArray = [UIStackView]()
    
    var delegate: PassDataBack?
    
    var eatingout = TransactionCategory.eatingout
    var shopping = TransactionCategory.shopping
    var groceries = TransactionCategory.groceries
    var fuel = TransactionCategory.fuel
    var general = TransactionCategory.general
    var bills = TransactionCategory.bills
    var travel = TransactionCategory.travel
    var investment = TransactionCategory.investment
    var entertainment = TransactionCategory.entertainment
    var sports = TransactionCategory.sports
    var kids = TransactionCategory.kids
    var other = TransactionCategory.other
    
    var buttonTitles = [String]()
    var buttonTitles2 = [String]()
    var buttonTitles3 = [String]()
    var buttonTitles4 = [String]()
    
    override func viewDidLoad() {
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(view)
        
        buttonTitles = [eatingout.rawValue, shopping.rawValue, groceries.rawValue]
        buttonTitles2 = [fuel.rawValue, general.rawValue, bills.rawValue]
        buttonTitles3 = [travel.rawValue, investment.rawValue, entertainment.rawValue]
        buttonTitles4 = [sports.rawValue, kids.rawValue, other.rawValue]
        
        row1 = setUpButtons(array: buttonTitles)
        row2 = setUpButtons(array: buttonTitles2)
        row3 = setUpButtons(array: buttonTitles3)
        row4 = setUpButtons(array: buttonTitles4)
        
        stackview1 = setUpStackView(buttons: row1)
        stackview2 = setUpStackView(buttons: row2)
        stackview3 = setUpStackView(buttons: row3)
        stackview4 = setUpStackView(buttons: row4)
        
        stackViewArray.append(stackview1)
        stackViewArray.append(stackview2)
        stackViewArray.append(stackview3)
        stackViewArray.append(stackview4)
        
        
        let sv = UIStackView(arrangedSubviews: stackViewArray)
        setUpButtonStackView(stackview: sv, view: view)
        
    }
    
    @objc func buttonTap(sender: UIButton) {
        switch sender.currentTitle {
        case eatingout.rawValue:
            delegate?.returnDataProtocol(data: eatingout.rawValue)
            dismiss(animated: true, completion: nil)
        case shopping.rawValue:
            delegate?.returnDataProtocol(data: shopping.rawValue)
            dismiss(animated: true, completion: nil)
        case groceries.rawValue:
            delegate?.returnDataProtocol(data: groceries.rawValue)
            dismiss(animated: true, completion: nil)
        case fuel.rawValue:
            delegate?.returnDataProtocol(data: fuel.rawValue)
            dismiss(animated: true, completion: nil)
        case general.rawValue:
            delegate?.returnDataProtocol(data: general.rawValue)
            dismiss(animated: true, completion: nil)
        case bills.rawValue:
            delegate?.returnDataProtocol(data: bills.rawValue)
            dismiss(animated: true, completion: nil)
        case travel.rawValue:
            delegate?.returnDataProtocol(data: travel.rawValue)
            dismiss(animated: true, completion: nil)
        case investment.rawValue:
            delegate?.returnDataProtocol(data: investment.rawValue)
            dismiss(animated: true, completion: nil)
        case entertainment.rawValue:
            delegate?.returnDataProtocol(data: entertainment.rawValue)
            dismiss(animated: true, completion: nil)
        case sports.rawValue:
            delegate?.returnDataProtocol(data: sports.rawValue)
            dismiss(animated: true, completion: nil)
        case kids.rawValue:
            delegate?.returnDataProtocol(data: kids.rawValue)
            dismiss(animated: true, completion: nil)
        default:
            delegate?.returnDataProtocol(data: other.rawValue)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setUpButtons(array: [String]) -> [UIButton] {
        
        var buttonArray = [UIButton]()
        
        for i in array {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 5
            button.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.9137254902, blue: 0.9568627451, alpha: 1)
            button.setTitle(i, for: .normal)
            
            switch (UIDevice().type) {
            case .iPod4, .iPod5, .iPhone4, .iPhone4S, .iPhone5, .iPhone5S, .iPhoneSE:
                button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
            default: //plus iPhones
                button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
            }
            
            button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 200).isActive = true
            button.heightAnchor.constraint(equalToConstant: 100).isActive = true
            button.addTarget(self, action: #selector(buttonTap(sender:)), for: UIControlEvents.touchUpInside)
            buttonArray.append(button)
        }
        
        return buttonArray
    }
    
    func setUpStackView(buttons: [UIButton]) -> UIStackView {
        let stackview = UIStackView(arrangedSubviews: buttons)
        stackview.spacing = 5
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillEqually
        return stackview
    }
    
    func setUpButtonStackView(stackview: UIStackView, view: UIView) {
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .fillEqually
        stackview.spacing = 5
        
        view.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
