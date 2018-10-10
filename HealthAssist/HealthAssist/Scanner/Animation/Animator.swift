//
//  Animator.swift
//  Mario
//
//  Created by Jon Hocking on 01/02/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import UIKit

public protocol Animator {
	
	typealias AnimatorCompletion = () -> Void
	
	func present(duration: TimeInterval, completion: AnimatorCompletion?)
	func dismiss(duration: TimeInterval, completion: AnimatorCompletion?)
	
}
