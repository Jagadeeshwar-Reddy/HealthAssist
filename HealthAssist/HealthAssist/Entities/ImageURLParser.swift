//
//  ImageURLParser.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 12/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import JSONUtilities

struct ImageURLParser {
    
    static func imageURL(from parsing: [String: Any], keyPath: String) -> URL? {
        guard let imageURL = (parsing.json(atKeyPath: keyPath) as URL?) else {
            return nil
        }
        if imageURL.absoluteString.contains("noimage") || imageURL.absoluteString.contains("no_image") {
            return nil
        }
        return imageURL
    }
}
