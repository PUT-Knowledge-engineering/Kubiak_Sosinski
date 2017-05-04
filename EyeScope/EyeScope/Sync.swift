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
            do {
                //let json = try JSONSerialization.jsonObject(with: response as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<AnyObject>

                //            for (_,catalog):(String, JSON) in json {
                //                let catalog = CatalogEntity(json: catalog)
                //                catalogs.append(catalog)
                //            }

                guard let json = response as? JSON else {
                    failure(NSError(domain: "", code: 0, userInfo: nil))
                    return
                }

                // dump(json)
                print(json)
                for catalog in json["dirs"] as? [JSON] ?? [] {
                    let catalog = CatalogEntity(json: catalog)
                    catalogs.append(catalog)
                }

                successful(catalogs)
            }
            catch {
                
            }
        }, failure: { (error) -> () in
            failure(error as NSError)
        }) }
    
}