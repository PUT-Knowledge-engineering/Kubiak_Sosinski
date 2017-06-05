//
//  EyePhotoViewModel.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 31.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import AlamofireImage

enum Side: Int, CustomStringConvertible {
    case Left = 0
    case Right = 1
    case Undefined = 2

    var description : String {
        switch self {
        case .Left: return "l"
        case .Right: return "r"
        case .Undefined: return "u"
        }
    }
}

class EyePhotoViewModel {

    let observableImage: Variable<UIImage> = Variable(UIImage())
    let observablePhase: Variable<Int?> = Variable(0)
    let observableSide: Variable<Int?> = Variable(2)
    var photo: EyePhoto
    let photoUrl: String

    private let disposeBag = DisposeBag()


    init(imageUrl: String, photo: EyePhoto) {
        self.photo = photo
        self.photoUrl = imageUrl
        setupObservables()
        downloadImage()
    }

    private func downloadImage() {
        let path = photoUrl.replacingOccurrences(of: "\\", with: "/", options: .literal, range: nil)
        print(path)
        let url = api.urlForPath(ApiPath.Photo, nil, path)
        Alamofire.request(url).responseImage{ response in
            DispatchQueue.main.async {
                if let image = response.result.value {
                    self.observableImage.value = image
                }
            }
        }
    }

    private func setupObservables() {
        observablePhase.asObservable()
            .subscribe(onNext: { [unowned self] (phase) in
                self.photo.phase = String(describing: (phase!))
        })
        .addDisposableTo(disposeBag)

        observableSide.asObservable()
            .subscribe(onNext: { [unowned self] (side) in
                self.photo.side = (Side.init(rawValue: side!)?.description)!
            })
            .addDisposableTo(disposeBag)
    }
}
