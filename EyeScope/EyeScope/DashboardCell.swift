//
//  DashboardCell.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 18.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import UIKit
import RxSwift

class DashboardCell: UITableViewCell {

    struct Constants {
        static let reuseIdentifier = "DashboardCell"
        static let estimatedHeight = CGFloat(200.0)
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    private let disposeBag = DisposeBag()

    var viewModel: DashboardCellViewModel! {
        didSet { bindViewModel() }
    }

    func bindViewModel() {
        nameLabel.text = viewModel.catalogName

        statusLabel.text = viewModel.status ? "DONE" : "TO DO"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension DashboardCell: Reusable {
    static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: nil) }
}
