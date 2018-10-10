//
//  NutritionInfoDetails.swift
//  TitanModel
//
//  Created by Priya Marwaha on 6/19/17.
//  Copyright © 2017 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

public struct MissingValuesInNutritionInfoError: Error {
	
	public let name: String
}
public struct NutritionInfoDetails {
	public let typicalValues: NutritionInfo
	public let referenceIntake: NutritionInfo?
	public let nutritionInfo: [NutritionInfo]?
	
	public init(jsonArray parsing: [JSONDictionary]) throws {
		
		var allNutritionInfo = parsing.compactMap { try? NutritionInfo(jsonDictionary: $0) }
		
		if let typicalValuesIndex = allNutritionInfo.index(where: { $0.isTypicalValuesInfo }) {
			typicalValues = allNutritionInfo.remove(at: typicalValuesIndex)
		} else {
			throw MissingValuesInNutritionInfoError(name: NutritionInfo.typicalValuesIdentifier)
		}
		
		if let referenceIntakeIndex = allNutritionInfo.index(where: { $0.isReferenceIntakeInfo }) {
			referenceIntake = allNutritionInfo.remove(at: referenceIntakeIndex)
		} else {
			referenceIntake = nil
		}
		nutritionInfo = allNutritionInfo
	}
}
