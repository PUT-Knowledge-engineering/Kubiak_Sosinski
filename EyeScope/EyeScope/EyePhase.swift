//
//  EyePhase.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 19.04.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EyePhase: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var phaseSegmentedControl: UISegmentedControl!

    let disposeBag = DisposeBag()

    var viewModel: EyePhotoViewModel! {
        didSet { bindViewModel() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        configure()
    }

    private func configure(){
        loadNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let sth = segmentedControl.selectedSegmentIndex
        let lol = phaseSegmentedControl.selectedSegmentIndex
    }

    func bindViewModel() {
        segmentedControl.rx.selectedSegmentIndex
            .changed
            .asObservable()
            .bindTo(viewModel.observableSide)
            .addDisposableTo(disposeBag)

        phaseSegmentedControl.rx.selectedSegmentIndex
            .changed
            .asObservable()
            .bindTo(viewModel
            .observablePhase)
            .addDisposableTo(disposeBag)

        viewModel.observableImage
        .asObservable()
        .bindTo(eyeImage.rx.image)
        .addDisposableTo(disposeBag)
    }

    private func loadNib() {
        Bundle.main.loadNibNamed("EyePhase", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        addSubview(content)
    }

}
