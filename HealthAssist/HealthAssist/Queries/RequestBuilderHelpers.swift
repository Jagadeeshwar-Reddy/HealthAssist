//
//  RequestBuilderHelpers.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

final class RequestBuilderHelpers {
    
    static let shared = RequestBuilderHelpers()
    
    func queryString(fromFile filename: String) -> String {
        let bundle = Bundle(for: type(of: self))
        guard let file = bundle.path(forResource: filename, ofType: "graphql"), let queryString = try? String(contentsOfFile: file) else {
            assertionFailure("GraphQL query file not found. Have you added it to the Xcode project?")
            return ""
        }
        
        return queryString
    }
    
    func json(with query: String, variables: [String: Any] = [:]) -> [String: Any]? {
        let json: [String: Any] = ["query": query, "variables": variables]
        return JSONSerialization.isValidJSONObject(json) ? json : nil
    }
}
