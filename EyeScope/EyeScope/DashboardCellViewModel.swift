//
//  DashboardCellViewModel.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 18.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation


class DashboardCellViewModel {

    var catalogName: String
    var status: Bool

    init(catalogName: String, status: Bool){
        self.catalogName = catalogName
        self.status = status
    }
}
