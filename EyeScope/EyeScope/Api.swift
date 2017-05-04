//
//  Api.swift
//  EyeScope
//
//  Created by Joanna Kubiak on 04.05.2017.
//  Copyright © 2017 joanna.kubiak. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

//http://eyescopeapi.azurewebsites.net/Home/Requests
//?key=qJW2KO0gKRSEdcXX

let key = "qJW2KO0gKRSEdcXX"

enum ApiPath: String {
    case CatalogList = "api/eye/catalog?key={key}"
    case Catalog = "api/eye/photo/{id}?key={key}"
    case Save = "api/eye/save/{id}?key={key}"
}

enum ResponseSerializerType {
    case json
    case image
    case text
}

enum ApiMethod {
    case get
    case post
    case delete
    case patch
}

typealias JSON = [AnyHashable: Any]

public func ==(lhs: [AnyHashable: Any], rhs: [AnyHashable: Any] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public func ==(lhs: [[AnyHashable: Any]], rhs: [[AnyHashable: Any]]) -> Bool {
    return NSArray(array: lhs).isEqual(to: rhs)
}

let api = {
    return Api.getInstance(false)
}()

open class Api: AFHTTPSessionManager {

    typealias ResponseOk = (Any) -> ()
    typealias ResponseError = (Error) -> ()

    fileprivate let kErrorDomain = "ReRiskErrorDomain"

    override init(baseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)

        requestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getInstance(_ backgroundMode: Bool) -> Api {
        let path: String

        path = "http://eyescopeapi.azurewebsites.net/"

        return Api(baseURL: URL(string: path), sessionConfiguration:
            .default)
    }

    /**
     Switch serializer depending on content type.

     - parameter type: response type (JSON/Image/text)
     */
    fileprivate func switchSerializer(_ type: ResponseSerializerType) {
        if type == .json {
            self.responseSerializer = AFJSONResponseSerializer()
            guard let acceptableContentTypes = self.responseSerializer.acceptableContentTypes else { return }
            var acceptable = Set(acceptableContentTypes)
            acceptable.insert("application/json")
            self.responseSerializer.acceptableContentTypes = acceptable
        } else if type == .image {
            self.responseSerializer = AFImageResponseSerializer()
            var acceptable = Set<String>()
            acceptable.insert("image/png")
            acceptable.insert("image/jpeg")
            acceptable.insert("image/jpg")
            self.responseSerializer.acceptableContentTypes = acceptable
        } else {
            self.responseSerializer = AFHTTPResponseSerializer()
            var acceptable = Set<String>()
            acceptable.insert("text/html")
            self.responseSerializer.acceptableContentTypes = acceptable
        }
    }

    /**
     Generate url for given API path

     - parameter path: api path
     - parameter id:   item ID (optional)

     - returns: <#return value description#>
     */
    fileprivate func urlForPath(_ path: ApiPath, _ id: Int?, _ key: String?) -> String {
        var urlPath = api.baseURL!.absoluteString
        urlPath += path.rawValue

        if let i = id {
            urlPath = urlPath.replacingOccurrences(of: "{id}", with: "\(i)",
                options: NSString.CompareOptions.caseInsensitive, range: nil)
        }

        if let k = key {
            urlPath = urlPath.replacingOccurrences(of: "{key}", with: "\(k)",
                options: NSString.CompareOptions.caseInsensitive, range: nil)
        }

        return urlPath
    }

    /**
     Take catalog list.

     - parameter successful: successful block
     - parameter failure:    failure block
     */
    func catalogs(successful: @escaping ResponseOk, failure: @escaping ResponseError) {
        switchSerializer(.json)

        let url = urlForPath(ApiPath.CatalogList, nil, key)

        get(url, parameters: [:], success: { (_, response) -> Void in
            successful(response)
        }) { (_, error) -> Void in
            failure(error)
        }
    }

    /**
     Catalog management.
     GET: fetch catalog.
     POST: upload given catalog json.

     - parameter catalogId:  catalog id
     - parameter method:     http method
     - parameter task:       if POST, the json to be uploaded.
     - parameter successful: successful block
     - parameter failure:    failure block
     */
    func catalog(_ catalogId: Int, _ method: ApiMethod = .get, dict: JSON? = nil, successful: @escaping ResponseOk, failure: @escaping ResponseError) {
        switch method {
        case .get:
            get(urlForPath(ApiPath.Catalog, catalogId, key), parameters: [:], success: { (_, response) -> Void in
                if let json = response as? JSON {
                    successful(json)
                }
            }) { (_, error) -> Void in
                failure(error)
            }
        case .post:
            let params = ["text": dict?["text"] as? String ?? ""]

            post(urlForPath(ApiPath.Save, catalogId, key), parameters: params as AnyObject!, success: { (_, response) -> Void in
                if let json = response as? JSON {
                    successful(json as AnyObject)
                }
            }) { (_, error) -> Void in
                failure(error)
            }
        default:
            print("Not implemented yet.")
        }
    }


}
