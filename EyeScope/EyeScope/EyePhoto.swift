//
//  EyePhoto.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 01.06.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import RxSwift

struct EyePhoto {
    let dir: String
    let name: String
    var side: String = "0"
    var phase: String = "0"
    var histogram: [Int] = [0]
    var size: [Int] = [0,0]

    init(dir: String, name: String) {
        self.dir = dir
        self.name = name
    }

    func toJson() -> JSON {
        return JSON()
    }
}
