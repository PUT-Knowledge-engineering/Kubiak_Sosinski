//
//  CommonData.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 04.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import SwiftyJSON

//protocol JsonExportable {
//    func toJson() -> JSON
//}

struct CatalogEntity {
    var name: String             = ""
    var processed: Bool          = false

    init(text: String) {
        self.name = text
    }

    init(json: JSON) {
        name = json["dir"] as? String ?? ""
        processed = json["status"] as? Bool ?? false
    }

    var hashValue: Int {
        get {
            return self.name.hashValue
        }
    }
}

struct CatalogList {
    var photos: [String] = []

    init(json: JSON) {
        photos = json["photos"] as? [String] ?? []
    }
    
}
