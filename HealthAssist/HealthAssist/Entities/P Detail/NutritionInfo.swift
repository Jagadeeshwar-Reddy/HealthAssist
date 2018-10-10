//
//  NutritionInfo.swift
//  TitanModel
//
//  Created by Priya Marwaha on 6/19/17.
//  Copyright © 2017 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

public struct NutritionInfo {
	public let name: String
	public let perComp: String?
	public let perServing: String?
	public let referenceIntake: String?
	public let referencePercentage: String?
	
	private static let referenceIntakeIdentifier = "Reference Intake"
	static let typicalValuesIdentifier = "Typical Values"
	
	private static let energyIdentifier = "Energy"
	
	public init(jsonDictionary parsing: JSONDictionary) throws {
		var nameValue: String = try parsing.json(atKeyPath: "name")
		
		if nameValue.containsIgnoringCase(NutritionInfo.referenceIntakeIdentifier), nameValue.hasPrefix("*") {
			let newStartIndex = nameValue.index(nameValue.startIndex, offsetBy: 1)
			nameValue = String(nameValue[newStartIndex...])
		}
		name = nameValue.trimmingWhitespace
		
		let perCompValue = try? parsing.trimmedValue(atKeyPath: "perComp")
		perComp = NutritionInfo.value(for: perCompValue)
		
		let perServingValue = try? parsing.trimmedValue(atKeyPath: "perServing")
		perServing = NutritionInfo.value(for: perServingValue)
		
		let referenceIntakeValue = try? parsing.trimmedValue(atKeyPath: "referenceIntake")
		referenceIntake = NutritionInfo.value(for: referenceIntakeValue)
		
		let referencePercentageValue = try? parsing.trimmedValue(atKeyPath: "referencePercentage")
		referencePercentage = NutritionInfo.value(for: referencePercentageValue)
	}
	
	private static func value(for nutritionValue: String?) -> String? {
		guard let value = nutritionValue else {
			return nil
		}
		return value == "-" || value.isEmpty ? nil: value
	}
}

public extension NutritionInfo {
	internal var isReferenceIntakeInfo: Bool {
		return name.containsIgnoringCase(NutritionInfo.referenceIntakeIdentifier)
	}
	
	internal var isTypicalValuesInfo: Bool {
		return name == NutritionInfo.typicalValuesIdentifier
	}
	
	public var isEnergyInfo: Bool {
		return name == NutritionInfo.energyIdentifier
	}
}
