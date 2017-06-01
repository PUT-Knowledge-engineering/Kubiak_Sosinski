//
//  ExtendedScrollView.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 31.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import UIKit

class ExtendedScrollView: UIScrollView {

    var hitTestEdgeInsets = UIEdgeInsets.zero

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if UIEdgeInsetsEqualToEdgeInsets(hitTestEdgeInsets, UIEdgeInsets.zero) {
            return super.point(inside: point, with: event)
        }
        let relativeFrame = bounds
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)

        return hitFrame.contains(point)
    }
}
