//
//  MainVC.swift
//  money-final
//
//  Created by Duy Le on 7/2/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class MainVC: RaisedTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 1
        
        self.insertEmptyClass("", atIndex: 1)
        let image = UIImage(named: "button")
        
        switch (UIDevice().type) {
        case .iPhoneX:
            self.addRaisedButton(image, highlightImage: nil, offSet: -45)
        default: //plus iPhones
            self.addRaisedButton(image, highlightImage: nil, offSet: -10)
        }
    }
    
    // Handler for raised button
    override func onRaisedButton(_ sender: UIButton!) {
        guard let addTransactionVC = storyboard?.instantiateViewController(withIdentifier: "AddTransactionVC") as? AddTransactionVC else { return }
        present(addTransactionVC, animated: true, completion: nil)
    }
    
}


