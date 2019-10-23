//
//  UIButtonExt.swift
//  Money-Manager
//
//  Created by Duy Le on 7/26/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.setTitleColor(#colorLiteral(red: 0.8549019608, green: 0.9137254902, blue: 0.9568627451, alpha: 1), for: .normal)
        self.backgroundColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
    }
    
    func setDeselectedColor() {
        self.layer.borderWidth = 1.5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0, green: 0.007843137255, blue: 0.1450980392, alpha: 1), for: .normal)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
