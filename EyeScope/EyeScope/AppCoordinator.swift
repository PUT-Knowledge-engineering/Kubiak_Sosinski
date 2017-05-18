//
//  AppCoordinator.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 18.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import UIKit

protocol AppCoordinatorDelegate: class {

}

class AppCoordinator: FlowCoordinator {

    let navigationController = UINavigationController()

    override func start() {

        navigationController.view.frame = config.window.bounds
        navigationController.navigationBar.isHidden = true

        config.window.rootViewController = navigationController
        config.window.makeKeyAndVisible()


        let dm = DashboardViewModel()
        let dashboardViewController = DashboardViewController(viewModel: dm)

        navigationController.pushViewController(dashboardViewController, animated: true)


        //TODO: Setup ViewController
    }
    
}

extension AppCoordinator: AppCoordinatorDelegate {
    
}
