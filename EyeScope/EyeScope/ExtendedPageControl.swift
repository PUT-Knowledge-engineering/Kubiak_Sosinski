//
//  ExtendedPageControl.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 31.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import UIKit

class ExtendedPageControl: UIPageControl {

    struct Constants {
        static let defaultIndicatorColor = UIColor(red:138/255,  green:147/255,  blue:255/255, alpha:1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateDots()
    }

    func updateDots() {
        for (index, dot) in subviews.enumerated() {
            if(index == self.currentPage){
                dot.backgroundColor = Constants.defaultIndicatorColor
                dot.layer.borderColor = Constants.defaultIndicatorColor.cgColor
                dot.layer.cornerRadius = dot.frame.size.height / 2
            } else {
                dot.backgroundColor = UIColor(red:1,  green:1,  blue:1, alpha:1)
                dot.layer.cornerRadius = dot.frame.size.height / 2
                dot.layer.borderColor = Constants.defaultIndicatorColor.cgColor
                dot.layer.borderWidth = 1;
            }
        }
    }
}
