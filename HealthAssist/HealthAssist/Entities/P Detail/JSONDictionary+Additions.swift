//
//  JSONDictionary+Additions.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

public struct EmptyValueError: Error {
    let keyPath: JSONUtilities.StringProtocol
    
    public init(keyPath: JSONUtilities.StringProtocol) {
        self.keyPath = keyPath
    }
}
public extension Dictionary where Key: JSONUtilities.StringProtocol, Value: Any {
    
    public func trimmedValue(atKeyPath: Key) throws -> String {
        let value: String = try json(atKeyPath: atKeyPath)
        return value.trimmingWhitespace
    }
    
    public func trimmedNonEmptyValue(atKeyPath: Key) -> String? {
        let value: String? = try? json(atKeyPath: atKeyPath)
        return value?.trimmingWhitespace.nilIfEmpty
    }
    
    public func trimmedNonEmptyValue(atKeyPath: Key) throws -> String {
        let value: String = try json(atKeyPath: atKeyPath)
        let trimmedValue = value.trimmingWhitespace
        if trimmedValue.isEmpty {
            throw EmptyValueError(keyPath: atKeyPath)
        }
        return trimmedValue
    }
    
    public func singleOrConcatenatedValue(atKeyPath keyPath: Key, separator: String) -> String? {
        return trimmedNonEmptyValue(atKeyPath: keyPath)
            ?? concatenatedValue(atKeyPath: keyPath, separator: separator)
    }
    
    public func concatenatedValue(atKeyPath keyPath: Key, separator: String) -> String? {
        guard let values: [String] = try? json(atKeyPath: keyPath) else {
            return nil
        }
        return values.joined(separator: separator).trimmingWhitespace.nilIfEmpty
    }
    
    public func concatenatedValuesSortedByKeys(atKeyPath keyPath: Key, separator: String) -> String? {
        guard let dictionary: JSONDictionary = try? json(atKeyPath: keyPath) else {
            return nil
        }
        let values = dictionary.valuesSortedByKeys().compactMap { $0 as? String }
        return values.joined(separator: separator).trimmingWhitespace.nilIfEmpty
    }
}

extension Dictionary where Key == String, Value: Any {
    
    private func sortedByKeys() -> [(key: String, value: Value)] {
        return sorted { (lhs, rhs) -> Bool in
            lhs.key.compare(rhs.key, options: [.numeric]) == .orderedAscending
        }
    }
    
    private func valuesSortedByKeys() -> [Value] {
        return sortedByKeys().map { $0.value }
    }
}
