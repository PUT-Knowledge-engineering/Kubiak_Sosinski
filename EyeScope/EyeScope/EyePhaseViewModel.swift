//
//  EyePhaseViewModel.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 31.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import RxSwift

protocol PhotosPageViewModelDelegate: class {
    func pop()
}

class EyePhaseViewModel {

    let observablePhotos: Variable<[(Int, EyePhotoViewModel)]> = Variable([])
    let numberOfPages: Variable<Int> = Variable(0)
    let photoDir: String
    var photoFolder: CatalogList?
    weak var delegate: PhotosPageViewModelDelegate?

    private let disposeBag = DisposeBag()

    init(folderUrl: Int, named photoDir: String) {
        self.photoDir = photoDir
        downloadPhotos(folderUrl: folderUrl)
    }

    private func downloadPhotos(folderUrl: Int) {
        fetchItemsWithCompletionBlock(folderUrl: folderUrl) {  [weak self] (error) -> Void in
            print("completed photo folder download")
        }
    }

    private func fetchItemsWithCompletionBlock(folderUrl: Int, _ completion: @escaping (_ error: Error?) -> Void) {
        sync.syncCatalog(catalogId: folderUrl, { (photos) -> (Void) in
            print("done fetching photo links")
            self.photoFolder = photos
            self.numberOfPages.value = photos.photos.count
            completion(nil)
        }) { (error) -> (Void) in
            completion(error)
        }
    }

    func save(_ viewModels: [EyePhotoViewModel]) {
        viewModels.forEach { (model) in
            print("Widok" + (model.photo.name) + String(describing: model.observablePhase.value))
        }
        delegate?.pop()
    }

    func pop() {
        delegate?.pop()
    }

    func createEyePhotoViewModel(forItem: Int, named photoName: String) -> EyePhotoViewModel {
        let viewModel = EyePhotoViewModel(imageUrl: photoName, photo: EyePhoto(dir: photoDir, name: photoName))

        return viewModel
    }
}
