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
    var index: Int

    init(catalogName: String, status: Bool, index: Int){
        self.catalogName = catalogName
        self.status = status
        self.index = index
    }
}
