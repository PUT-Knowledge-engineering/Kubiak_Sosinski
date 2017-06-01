//
//  PhotosPageController.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 31.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PhotosPageController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pagesView: ExtendedScrollView!

    private var pageFrame: CGRect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: 0))
    private var pageControl = ExtendedPageControl()
    private var currentPage = Variable<Int>(0)
    private let disposeBag = DisposeBag()
    private var photoViews: [EyePhase?] = []

    var rx_currentPage: UIBindingObserver<ExtendedPageControl,Int> {
        return pageControl.rx.currentPage
    }

    var viewModel: EyePhaseViewModel! {
        didSet { bindViewModel() }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }

//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.automaticallyAdjustsScrollViewInsets = false
//    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentPage.value = Int(pageNumber)
    }

    func bindViewModel() {
        viewModel.numberOfPages.asObservable()
            .skip(1)
            .subscribe(onNext: { number in
                self.createPages()
                self.configureBinds()
                self.configurePageControl()
                self.configureScrollView()
        }).addDisposableTo(disposeBag)

    }

    func configureBinds() {
        currentPage.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] number in
                self.pageControl.currentPage = number
                self.pageControl.updateDots()
            })
            .addDisposableTo(disposeBag)

        saveButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                var viewModels: [EyePhotoViewModel] = []
                self.photoViews.forEach({ (photoView) in
                    viewModels.append((photoView?.viewModel)!)
                })
                self.viewModel.save(viewModels)
            })
            .addDisposableTo(disposeBag)

        cancelButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.pop()
            })
            .addDisposableTo(disposeBag)
    }

    func configurePageControl() {
        pageControl.numberOfPages = viewModel.numberOfPages.value
        pageControl.currentPage = currentPage.value
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.bottom).offset(-25)
            make.width.equalTo(20)
            make.height.equalTo(12)
        }
    }

    func configureScrollView() {
        pagesView.delegate = self
        pagesView.showsHorizontalScrollIndicator = false
        pagesView.clipsToBounds = false
        pagesView.isPagingEnabled = true
        pagesView.hitTestEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
     //   motivationView.clipsToBounds = true
        for index in 0..<viewModel.numberOfPages.value {
            pageFrame.size = CGSize(width: pagesView.frame.size.width, height: self.pagesView.frame.size.height)
            if index == 0 {
                firstPhotoSetup(index)
            } else {
                nextPhotoSetup(index)
            }
        }
        self.pagesView.contentSize = CGSize(width: (pagesView.frame.size.width * CGFloat(viewModel.numberOfPages.value)), height: self.pagesView.frame.size.height)
    }


    private func firstPhotoSetup(_ index: Int) {
        pageFrame.origin.x = self.pagesView.frame.size.width * CGFloat(index)
        guard let photoView = photoViews[index] else { return }
        photoView.frame = pageFrame
        pagesView.addSubview(photoView)
    }

    private func nextPhotoSetup(_ index: Int) {
        pageFrame.origin.x = self.pagesView.frame.size.width * CGFloat(index)
        guard let photoView = photoViews[index] else { return }
        photoView.frame = CGRect(origin: CGPoint(x: pageFrame.origin.x, y: pageFrame.origin.y), size: CGSize(width: pagesView.frame.width, height: pageFrame.size.height))

        pagesView.addSubview(photoView)
    }

    private func createPages() {
        for index in 0..<viewModel.numberOfPages.value {
            photoViews.append(setupPhotoPage(index))
        }
    }

    private func setupPhotoPage(_ index: Int) -> EyePhase {
        let photoViewModel = viewModel.createEyePhotoViewModel(forItem: index, named: (viewModel.photoFolder?.photos[index])!)
        let photoView = EyePhase()
        photoView.viewModel = photoViewModel
        return photoView
    }
}
