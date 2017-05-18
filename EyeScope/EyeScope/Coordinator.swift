//
//  Coordinator.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 18.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import UIKit

class FlowCoordinator {
    var config: FlowConfig!

    func start() {}
    func flowDidFinish(coordinator: FlowCoordinator) {}

    init(config: FlowConfig) {
        self.config = config
    }
}

struct FlowConfig {
    let window: UIWindow!
    let navigationController: UINavigationController?
}
