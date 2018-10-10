//
//  UIView+NibLoading.swift
//  TescoNow
//
//  Created by Sam Dods on 20/09/2016.
//  Copyright © 2016 Tesco. All rights reserved.
//

import UIKit
import TABSwiftLayout

/// Protocol to be extended with implementations
public protocol UIViewLoading: UILoading {}

/// Extend UIView to declare that it includes nib loading functionality
extension UIView: UIViewLoading {}

/// Protocol implementation
public extension UIViewLoading where Self : UIView {
	
	/// UIView in resource bundle represented with .nib extension
	public static var resourceExtension: String { return "nib" }
	
	/// 	Creates a new instance of the class on which this method is invoked,
	/// 	instantiated from a nib of the given name. If no nib name is given
	/// 	then a nib with the name of the class is used.
	///
	/// - parameter nibNameOrNil:  The name of the nib to instantiate from, or
	/// 	nil to indicate the nib with the name of the class should be used.
	///
	/// - returns: A new instance of the class, loaded from a nib.
	public static func loadFromNib(nibNameOrNil: String? = nil) -> Self {
		let nibName = nibNameOrNil ?? self.className
		
		guard let nibBundle = getContainingBundle(nameOrNil: nibNameOrNil) else {
			fatalError("Nib \(nibName) does not contain an object of type \(self.className)")
		}
		
		let nib = UINib(nibName: nibName, bundle: nibBundle)
		
		guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
			fatalError("Nib \(nibName) does not contain an object of type \(self.className)")
		}
		
		return view
	}

	public func addContainedSubview(_ subview: UIView) {
		self.addSubview(subview)
		subview.pin(edges: .all, toView: self)
	}
	
	static var nib: UINib {
		let nibName = String(describing: self)
		guard let nibBundle = getContainingBundle(nameOrNil: nibName) else {
			fatalError("Nib \(nibName) does not contain an object of type \(nibName)")
		}
		return UINib(nibName: nibName, bundle: nibBundle)
	}
}
