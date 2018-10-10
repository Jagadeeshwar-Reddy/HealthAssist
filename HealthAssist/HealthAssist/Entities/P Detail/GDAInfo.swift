//
//  GDAInfo.swift
//  TitanModel
//
//  Created by Priya Marwaha on 6/16/17.
//  Copyright © 2017 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

public enum GDARating: String, CustomStringConvertible {
	case low = "LOW"
	case medium = "MEDIUM"
	case high = "HIGH"
	public var description: String {
		return self.rawValue.pascalCased
	}
}

public enum GDAType: String {
	case energy = "Energy"
	case fat = "Fat"
	case saturates = "Saturates"
	case sugars = "Sugars"
	case salt = "Salt"
}
public struct InvalidGDATypeError: Error {
	public let name: String
}

public struct GDAInfo: JSONObjectConvertible {
	public let type: GDAType
	public let value: String?
	public let percent: String?
	public let rating: GDARating?
	
	public init(jsonDictionary parsing: JSONDictionary) throws {
		let name: String = try parsing.json(atKeyPath: "name")
		guard let gdaType = GDAType(rawValue: name) else {
			throw InvalidGDATypeError(name: name)
		}
		
		let ratingValue: String? = parsing.json(atKeyPath: "rating")
		rating = ratingValue.flatMap(GDARating.init)
		
		type = gdaType
		value = parsing.json(atKeyPath: "value")
		percent = parsing.json(atKeyPath: "percent")
	}
}
