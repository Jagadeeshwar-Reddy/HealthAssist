//
//  Product.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

public final class Product: JSONObjectConvertible {
    
    public let id: String
    public let baseProductID: String
    public let title: String
    public let thumbnailURL: URL?
    public var details: ProductDetails?
    
    public init(jsonDictionary parsing: JSONDictionary) throws {
        id = try parsing.json(atKeyPath: "id")
        baseProductID = try parsing.json(atKeyPath: "baseProductId")
        title = try parsing.json(atKeyPath: "title")
        thumbnailURL = ImageURLParser.imageURL(from: parsing, keyPath: "defaultImageUrl")
    }
    
    enum HealthColorCode {
        case good
        case notRecommended
        case notGood
        case cantDetermine
        
        var colorCode: UIColor {
            switch self {
            case .good: return .green
            case .notRecommended: return .amber
            case .notGood: return .red
            default: return .clear
            }
        }
    }
    
    func healthCode(for profile: CustomerHealthProfile?) -> HealthColorCode {        
        guard let custProfile = profile else {
            return .cantDetermine
        }
        
        let carbohydrate = details?.nutritionInfoDetails?.nutritionInfo?.first(where: { $0.name == "Carbohydrate" })
        let fibre = details?.nutritionInfoDetails?.nutritionInfo?.first(where: { $0.name == "Fibre" })
        let sugars = details?.nutritionInfoDetails?.nutritionInfo?.first(where: { $0.name == "Sugars" })
        let protein = details?.nutritionInfoDetails?.nutritionInfo?.first(where: { $0.name == "Protein" })
        let fat = details?.nutritionInfoDetails?.nutritionInfo?.first(where: { $0.name == "Fat" })
        let salt = details?.nutritionInfoDetails?.nutritionInfo?.first(where: { $0.name == "Salt" })
        
        let carbohydratesPerServing = Double(carbohydrate?.perServing?.numbers ?? "0") ?? 0
        let fiberPerServing = Double(fibre?.perServing?.numbers ?? "0") ?? 0
        let fatPerServing = Double(fat?.perServing?.numbers ?? "0") ?? 0
        
        if custProfile.isDiabetic {
            if carbohydratesPerServing > 20 {
                return .notGood
            } else if case 15 ... 20 = carbohydratesPerServing, case 2 ... 3 = fiberPerServing {
                return .notRecommended
            } else if case 10 ... 15 = carbohydratesPerServing, case 0 ... 3 = fiberPerServing {
                return .good
            } else if carbohydratesPerServing < 15 {
                return .good
            }
        } else {
            if carbohydratesPerServing < 75, fatPerServing <= 15 {
                return .good
            } else if carbohydratesPerServing < 75, case 20 ... 30 = fatPerServing {
                return .notRecommended
            } else if carbohydratesPerServing > 75 && fatPerServing > 30 {
                return .notGood
            }
        }
        
        return .cantDetermine
    }
}

extension String {
    var numbers: String {
        return String(describing: filter { String($0).rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789.")) != nil })
    }
}
