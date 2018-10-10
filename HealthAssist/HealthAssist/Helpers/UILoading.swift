//
//  UILoading.swift
//  TescoUI
//
//  Created by Priya Marwaha on 4/4/17.
//  Copyright © 2017 Tesco. All rights reserved.
//

import UIKit

public protocol UILoading: class {
	
	static var resourceExtension: String { get }
}

/// Methods common to types that support loading of UI components
extension UILoading {
	
	/// Swift class name of current type
	static internal var className: String {
		let className = "\(self)"
		return getLastStringAfterPeriod(for: className)

	}

	/// Splits value by . and returns last value or the original value if there are no .
	/// - parameter value: Original string value
	static internal func getLastStringAfterPeriod(for value: String) -> String {
		let components = value.split { $0 == "." }.map(String.init)
		return components.last ?? value
	}
	
	/// Gets the bundle that contains the named UI component
	/// - parameter nameOrNil: Specific name of the component or the class name of current component
	static func getContainingBundle(nameOrNil: String? = nil) -> Bundle? {
		let nibName = nameOrNil ?? self.className
		let bundle = Bundle(for: self)
		return getBundle(resourceName: nibName, rootBundle: bundle, type: resourceExtension)
	}
	
	/// Gets bundle that contains the named UI component
	/// - parameter nibName: Name of UI component
	/// - parameter rootBundle: Bundle that contains the current type's class. UI component will be contained either in this rootBundle or in a child bundle within it.
	/// - parameter type: Extension type of UI component in bundle
	static internal func getBundle(resourceName: String, rootBundle: Bundle, type: String) -> Bundle? {
		
		// looks for a bundle for resource with specified type
		if let _ = rootBundle.path(forResource: resourceName, ofType: type) {
			return rootBundle
		}
		
		//check if resource is present in a child "bundle" resource inside the root bundle. This usually happens if the resource is bundled in a CocoaPods framework in a resource bundle.
		// we check for a bundle with the same name as the root bundle (e.g. if rootBundle's identifier is org.cocoapods.TescoIdentityUI, we check for a child bundle named TescoIdentityUI.bundle, which is how CocoaPods creates it by default
		guard let bundleIdentifier = rootBundle.bundleIdentifier else {
			return nil
		}
		
		let bundleResourceName = getLastStringAfterPeriod(for: bundleIdentifier)
		
		// get resource bundle and check path for resource inside it
		guard let bundleURL = rootBundle.url(forResource: bundleResourceName, withExtension: "bundle"),
			let bundle = Bundle(url: bundleURL), let _ = bundle.path(forResource: resourceName, ofType: type) else {
				return nil
		}
		
		return bundle
	}
	
}
