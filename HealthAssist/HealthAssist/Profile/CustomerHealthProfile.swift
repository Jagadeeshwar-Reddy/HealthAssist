//
//  CustomerHealthProfile.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

final class CustomerHealthProfile: JSONObjectConvertible {
    enum BiologicalSex: String {
        case Male, Female
    }
    
    let name: String
    let dateOfBirth: Date
    let biologicalSex: BiologicalSex
    let bodyMassIndex: Double
    let height: Double
    let bodyMass: Double
    let activeEnergy: Double
    let bodyFatPercentage: Int
    let oxygenSaturation: Double
    let age: Int
    let bloodGlucose: Double
    
    init(jsonDictionary: JSONDictionary) throws {
        name = try jsonDictionary.json(atKeyPath: "name")
        let dateString: String = try jsonDictionary.json(atKeyPath: "dateOfBirth")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        dateOfBirth = dateFormatter.date(from: dateString)!
        
        let today = Date()
        let calendar = Calendar.current
        let todayDateComponents = calendar.dateComponents([.year],
                                                          from: today)
        let thisYear = todayDateComponents.year!
        age = thisYear - calendar.dateComponents([.year], from: dateOfBirth).year!
        
        biologicalSex = try jsonDictionary.json(atKeyPath: "biologicalSex")
        bodyMassIndex = try jsonDictionary.json(atKeyPath: "bodyMassIndex")
        height = try jsonDictionary.json(atKeyPath: "height")
        bodyMass = try jsonDictionary.json(atKeyPath: "bodyMass")
        activeEnergy = try jsonDictionary.json(atKeyPath: "activeEnergy")
        bodyFatPercentage = try jsonDictionary.json(atKeyPath: "bodyFatPercentage")
        oxygenSaturation = try jsonDictionary.json(atKeyPath: "oxygenSaturation")
        bloodGlucose = try jsonDictionary.json(atKeyPath: "bloodGlucose")
    }
    
    var isDiabetic: Bool {
        return bloodGlucose > 140
    }
}
