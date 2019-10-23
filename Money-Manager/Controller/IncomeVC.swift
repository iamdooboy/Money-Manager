//
//  IncomeVC.swift
//  Money-Manager
//
//  Created by Duy Le on 7/27/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class IncomeVC: UIViewController {

    var row1 = [UIButton]()
    var row2 = [UIButton]()
    var row3 = [UIButton]()
    
    var stackview1 : UIStackView!
    var stackview2 : UIStackView!
    var stackview3 : UIStackView!
    
    var stackViewArray = [UIStackView]()
    
    var delegate: PassDataBack?
    
    var salary = TransactionCategory.salary
    var carryover = TransactionCategory.carryover
    var allowance = TransactionCategory.allowance
    var gift = TransactionCategory.gifts
    var dividend = TransactionCategory.dividends
    var royalty = TransactionCategory.royalty
    var reward = TransactionCategory.rewards
    var cashback = TransactionCategory.cashback
    var other = TransactionCategory.other
    
    var buttonTitles = [String]()
    var buttonTitles2 = [String]()
    var buttonTitles3 = [String]()
    
    override func viewDidLoad() {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(view)

        buttonTitles = [salary.rawValue, carryover.rawValue, allowance.rawValue]
        buttonTitles2 = [gift.rawValue, dividend.rawValue, royalty.rawValue]
        buttonTitles3 = [reward.rawValue, cashback.rawValue, other.rawValue]

        row1 = setUpButtons(array: buttonTitles)
        row2 = setUpButtons(array: buttonTitles2)
        row3 = setUpButtons(array: buttonTitles3)

        stackview1 = setUpStackView(buttons: row1)
        stackview2 = setUpStackView(buttons: row2)
        stackview3 = setUpStackView(buttons: row3)

        stackViewArray.append(stackview1)
        stackViewArray.append(stackview2)
        stackViewArray.append(stackview3)


        let sv = UIStackView(arrangedSubviews: stackViewArray)
        
        setUpButtonStackView(stackview: sv, view: view)
    
    }
    
    @objc func buttonTap(sender: UIButton) {
        switch sender.currentTitle {
        case salary.rawValue:
            delegate?.returnDataProtocol(data: salary.rawValue)
            dismiss(animated: true, completion: nil)
        case carryover.rawValue:
            delegate?.returnDataProtocol(data: carryover.rawValue)
            dismiss(animated: true, completion: nil)
        case allowance.rawValue:
            delegate?.returnDataProtocol(data: allowance.rawValue)
            dismiss(animated: true, completion: nil)
        case gift.rawValue:
            delegate?.returnDataProtocol(data: gift.rawValue)
            dismiss(animated: true, completion: nil)
        case dividend.rawValue:
            delegate?.returnDataProtocol(data: dividend.rawValue)
            dismiss(animated: true, completion: nil)
        case royalty.rawValue:
            delegate?.returnDataProtocol(data: royalty.rawValue)
            dismiss(animated: true, completion: nil)
        case reward.rawValue:
            delegate?.returnDataProtocol(data: reward.rawValue)
            dismiss(animated: true, completion: nil)
        case cashback.rawValue:
            delegate?.returnDataProtocol(data: cashback.rawValue)
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
            button.heightAnchor.constraint(equalToConstant: 120).isActive = true
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
