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
    var photoFolder: CatalogList?
    let numberOfPages: Variable<Int> = Variable(0)
//    let phaseVariables: Variable<[(Int, Int)]> = Variable([])
    let photoDir: String
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

//        phaseVariables.asObservable().subscribe(onNext: { (photo) in
//            photo.forEach({ (pho: (Int, Int)) in
//            print("hm" + String(pho.1))
//            })
//        }).addDisposableTo(disposeBag)
//
//        observablePhotos.asObservable().subscribe(onNext: { (photo) in
//            photo.forEach({ (pho) in
//                print("Sprawdzenie")
//            })
//        }).addDisposableTo(disposeBag)
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
//        Observable.just(viewModel)
//            .map{return (forItem, $0)}
//            .subscribe(onNext: { [unowned self] (index, model) in
//                self.findPhoto(index: index, model: model)
//            })
//            .addDisposableTo(disposeBag)

//        viewModel.observablePhase.asObservable()
//            .map{ return (forItem, $0!) }
//            .subscribe(onNext: { [unowned self] phase in
//                self.phaseVariables.value.append(phase)
//            })
//            .addDisposableTo(disposeBag)

        return viewModel
    }

    func findPhoto(index: Int, model: EyePhotoViewModel) {
        var found = (false, 0)
        for (id, photo) in observablePhotos.value.enumerated() {
            if photo.0 == index {
                found = (true, id)
        }
        }
        if found.0 {
            observablePhotos.value[found.1].1 = model
        }
        else {
            observablePhotos.value.append(index, model)
        }
    }
}
