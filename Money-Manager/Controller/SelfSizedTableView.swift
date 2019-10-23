//
//  SelfSizedTableView.swift
//  money-final
//
//  Created by Duy Le on 7/13/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}

