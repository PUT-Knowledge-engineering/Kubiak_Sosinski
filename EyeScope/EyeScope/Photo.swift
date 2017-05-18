//
//  EyeScope.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 18.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation


class Photo {
    var dirName: String
    var photoName: String
    var side: String
    var phase: Int
    var histogram: [Int]
    var size: (Int, Int)
    var photoUrl: String

    init(dirName: String, photoName: String, side: String, phase: Int, histogram: [Int], size: (Int, Int), photoUrl: String) {
        self.dirName = dirName
        self.photoName = photoName
        self.side = side
        self.phase = phase
        self.histogram = histogram
        self.size = size
        self.photoUrl = photoUrl
    }
}
