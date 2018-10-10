//
//  TimingCurves.swift
//  Mario
//
//  Created by Jon Hocking on 01/02/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import UIKit

extension TimeInterval {
	static var defaultDuration: TimeInterval { return 0.28 }
	static var fadeDuration: TimeInterval { return 0.35 }
}

struct TimingCurve {
	
	static var onOffScreen: UITimingCurveProvider {
		return MarioOnOffScreenTimingCurve()
	}
	
	static var showHideElement: UITimingCurveProvider {
		return UICubicTimingParameters(controlPoint1: CGPoint(x: 0.35, y: 0.16), controlPoint2: CGPoint(x: 0, y: 1))
	}
	
}

class TescoBaseTimingCurve: UITimingCurveProvider {
	
	func copy(with zone: NSZone? = nil) -> Any {
		return type(of: self).init() as Any
	}
	
	func encode(with aCoder: NSCoder) { }
	
	required init?(coder aDecoder: NSCoder) { }
	
	required init() { }
	
	var timingCurveType: UITimingCurveType { return .builtin }
	
	var cubicTimingParameters: UICubicTimingParameters? {
		return UICubicTimingParameters(animationCurve: .easeInOut)
	}
	
	var springTimingParameters: UISpringTimingParameters? {
		return nil
	}
	
}

final private class MarioOnOffScreenTimingCurve: TescoBaseTimingCurve {
	
	override var timingCurveType: UITimingCurveType { return .composed }
	
	override var cubicTimingParameters: UICubicTimingParameters? {
		return UICubicTimingParameters(controlPoint1: CGPoint(x: 0.35, y: 0.16), controlPoint2: CGPoint(x: 0, y: 1))
	}
	
	override var springTimingParameters: UISpringTimingParameters? {
		return UISpringTimingParameters(mass: 0.06, stiffness: 11, damping: 1.35, initialVelocity: CGVector.zero)
	}
	
}
