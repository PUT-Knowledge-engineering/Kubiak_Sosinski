//
//  DashboardViewModel.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 18.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

typealias FolderSection = SectionModel<String, DashboardCellViewModel>

class DashboardViewModel {
    let observableSections: Variable<[FolderSection]> = Variable([])
    let observableFolders: Variable<[CatalogEntity]> = Variable([])

    private let disposeBag = DisposeBag()

    init() {
        setupFoldersObserver()
    }

    private func setupFoldersObserver() {

        fetchItemsWithCompletionBlock {
            [weak self] (error) -> Void in
            print("completed folder download")
        }

        observableFolders.asObservable()
            .map(DashboardViewModel.logSectionsForLogs)
            .bindTo(observableSections)
            .addDisposableTo(disposeBag)

        }


    private func fetchItemsWithCompletionBlock(_ completion: @escaping (_ error: Error?) -> Void) {
        sync.syncCatalogs({ (catalogs) -> (Void) in
            print("done fetching")
            self.observableFolders.value = catalogs
            completion(nil)
        }, failure: { (error) -> (Void) in
            completion(error)
        })
    }

    private class func logSectionsForLogs(catalogs: [CatalogEntity]) -> [FolderSection] {
        var sections = [FolderSection]()
        var catalogViewModel = [DashboardCellViewModel]()

        catalogs.forEach { catalog in
            catalogViewModel.append(DashboardCellViewModel(catalogName: catalog.name, status: catalog.processed))
        }

        sections.append(FolderSection(model: "Catalogs", items: catalogViewModel))

        return sections
    }

}
