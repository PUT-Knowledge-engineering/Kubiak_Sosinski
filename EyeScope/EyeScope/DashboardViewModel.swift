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

enum CatalogStatus {
    case Done
    case ToDo
    case All
}

protocol DashboardViewModelDelegate: class {
    func folderChoosen(withFolder folder: Int, named: String)
}

class DashboardViewModel {
    let observableSections: Variable<[FolderSection]> = Variable([])
    let observableFolders: Variable<[CatalogEntity]> = Variable([])
    let filteredSections: Variable<[FolderSection]> = Variable([])
    let status: Variable<CatalogStatus> = Variable(.All)
    weak var delegate: DashboardViewModelDelegate?

    private let disposeBag = DisposeBag()

    init() {
        setupFoldersObserver()
    }

    private func setupFoldersObserver() {

        fetchItemsWithCompletionBlock {
            [weak self] (error) -> Void in
            print("completed folder download")
        }

        let sections = observableFolders.asObservable()
            .map(DashboardViewModel.logSectionsForLogs)
            .shareReplay(1)

        sections.asObservable()
        .bindTo(observableSections)
        .addDisposableTo(disposeBag)

        }


    func fetchItemsWithCompletionBlock(_ completion: @escaping (_ error: Error?) -> Void) {
        sync.syncCatalogs({ (catalogs) -> (Void) in
            print("done fetching")
            self.observableFolders.value = catalogs
            completion(nil)
        }, failure: { (error) -> (Void) in
            print(error)
            completion(error)
        })
    }

    private class func logSectionsForLogs(catalogs: [CatalogEntity]) -> [FolderSection] {
        var sections = [FolderSection]()
        var catalogViewModel = [DashboardCellViewModel]()

        for (id, catalog) in catalogs.enumerated() {
            catalogViewModel.append(DashboardCellViewModel(catalogName: catalog.name, status: catalog.processed, index: id))
        }
        sections.append(FolderSection(model: "Catalogs", items: catalogViewModel))

        return sections
    }

    func chooseFolder(folder: Int, named: String) {
        delegate?.folderChoosen(withFolder: folder, named: named)
    }

}
