//
//  ViewController.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 19.04.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        statusLabel.text = "Pobieram"
       // hud.label.text = "Loading..."
        fetchItemsWithCompletionBlock {
            [weak self] (error) -> Void in
            print("completed")
            self?.statusLabel.text = "Pobrane"
      //      if error != nil { self?.showUnableToLoadAlert() }
      //      self?.tableView.reloadData()
      //      self?.refreshControl?.endRefreshing()
      //      self?.navigationController?.navigationBar.isUserInteractionEnabled = true
      //      hud.hide(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchItemsWithCompletionBlock(_ completion: @escaping (_ error: Error?) -> Void) {
        sync.syncCatalogs({ (catalogs) -> (Void) in
            print("done")
            completion(nil)
        }, failure: { (error) -> (Void) in
            completion(error)
        })
    }

}

