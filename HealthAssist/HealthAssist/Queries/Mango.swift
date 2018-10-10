//
//  Search.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import Alamofire
import JSONUtilities

final class Mango {
    static let headers: HTTPHeaders = [
        "X-APIKEY": "32zM9EJvvTXWGWGgyOcYZtmr25STLtTT",
        "Accept": "application/json"
    ]
    
    static let baseURL = "https://tesco-prod-ppe.apigee.net/mango/"
    
    static func searchForProduct(name: String, completionHandler: @escaping ([Product]?) -> Void) {
        let query = RequestBuilderHelpers.shared.json(
            with: RequestBuilderHelpers.shared.queryString(fromFile: "SearchProduct"),
            variables: [
                "business": "grocery",
                "query": name,
                "page": 1,
                "count": 10,
                "storeId": "6440"                
            ])
        Alamofire.request(baseURL, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let jsonDictionary = response.result.value as? JSONDictionary,
                let products: [Product] = try? jsonDictionary.json(atKeyPath: "data.search.productItems") {
                
                var productDetailFetchCount = products.count
                products.forEach({ product in
                    productDetail(id: product.id, completionHandler: { details in
                        product.details = details
                        productDetailFetchCount -= 1
                        if productDetailFetchCount == 0 {
                            completionHandler(products)
                        }
                    })
                })
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func searchForProduct(barcode: String, completionHandler: @escaping (Product?) -> Void) {
        let query = RequestBuilderHelpers.shared.json(
            with: RequestBuilderHelpers.shared.queryString(fromFile: "GetProduct"),
            variables: [
                "barcode": barcode
            ])
        Alamofire.request(baseURL, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let jsonDictionary = response.result.value as? JSONDictionary,
                let productJson = try? jsonDictionary.json(atKeyPath: "data.product"),
                let product = try? Product(jsonDictionary: productJson) {
                print(product)
                productDetail(id: product.id, completionHandler: { details in
                    product.details = details
                    
                    completionHandler(product)
                })
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func offerProducts(completionHandler: @escaping ([Product]?) -> Void) {
        let query = RequestBuilderHelpers.shared.json(
            with: RequestBuilderHelpers.shared.queryString(fromFile: "GetOffers"),
            variables: [
                "promotionType": "alloffers",
                "page": 1,
                "count": 20,
            ])
        
        Alamofire.request(baseURL, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let jsonDictionary = response.result.value as? JSONDictionary,
                let products: [Product] = try? jsonDictionary.json(atKeyPath: "data.promotionType.productItems") {
                
                var productDetailFetchCount = products.count
                products.forEach({ product in
                    productDetail(id: product.id, completionHandler: { details in
                        product.details = details
                        productDetailFetchCount -= 1
                        if productDetailFetchCount == 0 {
                            completionHandler(products)
                        }
                    })
                })
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func productDetail(id: String, completionHandler: @escaping (ProductDetails?) -> Void) {
        let query = RequestBuilderHelpers.shared.json(
            with: RequestBuilderHelpers.shared.queryString(fromFile: "GetProductDetails"),
            variables: [
                "business": "grocery",
                "productId": id,
                "storeId": "6440"
            ])
        Alamofire.request(baseURL, method: .post, parameters: query, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let jsonDictionary = response.result.value as? JSONDictionary,
                let productJson = try? jsonDictionary.json(atKeyPath: "data.product") {
                let productDetails = ProductDetails(jsonDictionary: productJson)
                completionHandler(productDetails)
            } else {
                completionHandler(nil)
            }
        }
    }
}
