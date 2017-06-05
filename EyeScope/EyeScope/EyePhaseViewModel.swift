//
//  EyePhaseViewModel.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 31.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol PhotosPageViewModelDelegate: class {
    func pop()
}

class EyePhaseViewModel {

    let observablePhotos: Variable<[(Int, EyePhotoViewModel)]> = Variable([])
    let numberOfPages: Variable<Int> = Variable(0)
    let photoDir: String
    let catalogNumber: Int
    var photoFolder: CatalogList?
    weak var delegate: PhotosPageViewModelDelegate?

    private let disposeBag = DisposeBag()

    init(folderUrl: Int, named photoDir: String) {
        self.photoDir = photoDir
        self.catalogNumber = folderUrl
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
        var photos: [[String : Any]] = []

        viewModels.forEach { (model) in
            let photo: [String : Any] = [
                "dir" : model.photo.dir,
                "name" : model.photo.name,
                "side" : model.photo.side,
                "phase" : model.photo.phase,
                "histogram" : model.photo.histogram,
                "size" : [350, 200]
            ]
            photos.append(photo)
        }

        let dict: SwiftyJSON.JSON = ["photos" : photos]
        let serializedDict = dict.dictionaryObject

        //dump(serializedDict)

        sync.saveCatalog(catalogId: catalogNumber, dict: serializedDict, { [unowned self] (response) in
            self.pop()
        })
        { (error) -> (Void) in
            print(error)
        }

    }

    func pop() {
        delegate?.pop()
    }

    func createEyePhotoViewModel(forItem: Int, named photoName: String) -> EyePhotoViewModel {
        let viewModel = EyePhotoViewModel(imageUrl: photoName, photo: EyePhoto(dir: photoDir, name: photoName))

        return viewModel
    }
}
