//
//  Sync.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 04.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import SwiftyJSON

let sync = Sync()

class Sync {

    func syncCatalogs(_ successful: @escaping (Array<CatalogEntity>) -> (Void), failure: @escaping (Error) -> (Void)) {
        var catalogs = Array<CatalogEntity>()

        api.catalogs(successful: { (response) -> () in
                guard let json = response as? JSON else {
                    failure(NSError(domain: "", code: 0, userInfo: nil))
                    return
                }
                // dump(json)
                for catalog in json["dirs"] as? [JSON] ?? [] {
                    let catalog = CatalogEntity(json: catalog)
                    catalogs.append(catalog)
                }

                successful(catalogs)
        }, failure: { (error) -> () in
            failure(error as NSError)
        })
    }

    func syncCatalog(catalogId: Int, _ successful: @escaping (CatalogList) -> (Void), failure: @escaping (Error) -> (Void)) {

        api.catalog(catalogId, successful: { (response) -> () in
            guard let json = response as? JSON else {
                failure(NSError(domain: "", code: 0, userInfo: nil))
                return
            }
            // dump(json)
            let photos = CatalogList(json: json)

            successful(photos)
        }, failure: { (error) -> () in
            failure(error as NSError)
        })
    }

}
