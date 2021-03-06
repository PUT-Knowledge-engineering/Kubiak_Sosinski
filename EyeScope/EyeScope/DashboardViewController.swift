//
//  DashboardViewController.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 19.04.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel: DashboardViewModel
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<FolderSection>()

    private let disposeBag = DisposeBag()

    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureTableViewDataSource()
        configureTableViewDelegate()
        bindToViewModel()

        //self.view.backgroundColor = UIColor(red:0.80, green:1.00, blue:0.80, alpha:1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.fetchItemsWithCompletionBlock {
            [weak self] (error) -> Void in
            print("completed folder download")
        }
    }

    private func configureTableView(){
        tableView.registerReusableCell(DashboardCell.self)
        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)

        let footerView = UIView(frame: CGRect(x: 0, y: 0,
                                              width: tableView.bounds.width, height: 0))
        footerView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footerView
        self.automaticallyAdjustsScrollViewInsets = true
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 219 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1.0)
            //UIColor(red:0.18, green:0.23, blue:0.52, alpha:1.00)
    }

    private func bindToViewModel(){
    }

    private func configureTableViewDataSource() {
       // dataSource.configureCell = DashboardViewController.createCell

        dataSource.configureCell = { ds, tv, ip, item in
            let cell: DashboardCell = self.tableView.dequeueReusableCell(indexPath: ip as NSIndexPath)
            cell.viewModel = item
            //cell.backgroundColor = UIColor(red:1.00, green:1.00, blue:0.90, alpha:1.0)

            return cell
        }

        viewModel.observableSections.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }

    private class func createCellInTableView(tableView: UITableView, indexPath: NSIndexPath,
                                                  viewModel: DashboardCellViewModel) -> DashboardCell {

        let cell: DashboardCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.viewModel = viewModel as? DashboardCellViewModel

        return cell
    }

    private func configureTableViewDelegate() {


        tableView.rx.itemSelected.map { indexPath in
            return (indexPath, self.dataSource[indexPath])
            }
            .subscribe(onNext: { [unowned self] indexPath, model in
                self.viewModel.chooseFolder(folder: model.index, named: model.catalogName)
            })
            .addDisposableTo(disposeBag)
    }
}


extension DashboardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width,
                                              height: 70))
        headerView.backgroundColor = UIColor(red: 156 / 255,  green: 177 / 255,  blue: 255 / 255, alpha: 1.0)

        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont(name: "SofiaProSoft-Medium", size: 12)
        label.textColor = UIColor(red:0.18, green:0.23, blue:0.52, alpha:1.00)
        headerView.addSubview(label)

        let section = "CATALOGS"
        label.text = section

        label.snp.makeConstraints { make in
            make.left.equalTo(headerView.snp.left).offset(23)
            make.bottom.equalTo(headerView.snp.bottom).offset(-10)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

