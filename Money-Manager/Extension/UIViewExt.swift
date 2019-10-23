//
//  UIViewExt.swift
//  Money-Manager
//
//  Created by Duy Le on 8/3/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

extension UIView {
    func leftTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromRight
        animation.duration = duration
        layer.add(animation, forKey: kCATransition)
    }
    
    func rightTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromLeft
        animation.duration = duration
        layer.add(animation, forKey: kCATransition)
    }
}
