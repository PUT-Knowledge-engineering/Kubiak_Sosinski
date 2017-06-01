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
        dm.delegate = self
        let dashboardViewController = DashboardViewController(viewModel: dm)

        navigationController.pushViewController(dashboardViewController, animated: true)
    }
    
}

extension AppCoordinator: AppCoordinatorDelegate {
    
}

extension AppCoordinator: DashboardViewModelDelegate {
    func folderChoosen(withFolder folder: Int, named: String) {
        showPhotosPageController(withFolder: folder, named: named)
    }

    private func showPhotosPageController(withFolder folder: Int, named photoDir: String) {
        navigationController.navigationBar.isHidden = true
        let photosPageController = PhotosPageController()
        let viewModel = EyePhaseViewModel(folderUrl: folder, named: photoDir)
        viewModel.delegate = self
        photosPageController.viewModel = viewModel
        navigationController.pushViewController(photosPageController, animated: true)
    }
}

extension AppCoordinator: PhotosPageViewModelDelegate {
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
