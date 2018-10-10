//
//  String+Additions.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

extension String {
    var pascalCased: String {
        let prefix = self.prefix(1).capitalized
        let suffix = self.dropFirst().lowercased()
        return prefix + suffix
    }
    var trimmingWhitespace: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var nilIfEmpty: String? {
        return isEmpty ? nil : self
    }
    
    func containsIgnoringCase(_ find: String) -> Bool {
        return range(of: find, options: .caseInsensitive) != nil
    }
}
