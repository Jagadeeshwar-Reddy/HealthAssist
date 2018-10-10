//
//  Container.swift
//  HealthAssist
//
//  Created by Jagadeeshwar Reddy on 13/07/18.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation

final class Container {
    static let resolver = Container()
    
    var currentProfile: CustomerHealthProfile?
}
