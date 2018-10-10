//
//  ProductDetails.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

public struct ProductDetails: JSONObjectConvertible {
    public let name: String?
    public let gdaInfo: [GDAType: GDAInfo]?
    public let nutritionInfoDetails: NutritionInfoDetails?
    
    public init(jsonDictionary detailsJSON: JSONDictionary) {
        name = detailsJSON.json(atKeyPath: "title")
        gdaInfo = ProductDetails.guidelineDailyAmounts(from: detailsJSON)
        nutritionInfoDetails = ProductDetails.nutritionalInfo(from: detailsJSON)
    }
    
    static private func guidelineDailyAmounts(from productJSON: JSONDictionary) -> [GDAType: GDAInfo]? {
        guard let gdaDetails: [GDAInfo] = productJSON.json(atKeyPath: "details.gda") else { return nil }
        let keyValuePairs = gdaDetails.compactMap { ($0.type, $0) }
        return keyValuePairs.isEmpty ? nil : Dictionary(uniqueKeysWithValues: keyValuePairs)
    }
    
    // MARK: - Nutritional Info
    
    static private func nutritionalInfo(from productJSON: JSONDictionary) -> NutritionInfoDetails? {
        guard let nutritionDetailsJSONArray: [JSONDictionary] = productJSON.json(atKeyPath: "details.nutritionInfo") else { return nil }
        return try? NutritionInfoDetails(jsonArray: nutritionDetailsJSONArray)
    }
}
