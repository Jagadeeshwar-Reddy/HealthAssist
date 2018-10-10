//
//  CrosshairView.swift
//  TescoTitan
//
//  Created by Jon Hocking on 06/12/2017.
//  Copyright © 2017 Tesco. All rights reserved.
//

import UIKit

public final class CrosshairView: UIView {

	private let lineWidth: CGFloat = 4
	private let armLength: CGFloat = 50
	private let crossHairSize = CGSize(width: 200, height: 200)
	
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
		setupColors()
		let crossHairPath = self.crossHairPath(fittingSize: bounds.size)
		crossHairPath.stroke()
	}
	
	private func setupColors() {
		UIColor.clear.setFill()
		UIColor.white.setStroke()
	}
	
	private func crossHairPath(fittingSize size: CGSize) -> UIBezierPath {
		let fullPath = UIBezierPath()
		let bottomRightPath = pathForBottomRightCorner(fittingSize: size)
		fullPath.append(bottomRightPath)
		
		let topRightPath = pathForTopRightCorner(fittingSize: size)
		fullPath.append(topRightPath)
		
		let topLeftPath = pathForTopLeftCorner(fittingSize: size)
		fullPath.append(topLeftPath)
		
		let bottomLeftPath = pathForBottomLeftCorner(fittingSize: size)
		fullPath.append(bottomLeftPath)

		fullPath.lineWidth = lineWidth
		fullPath.lineCapStyle = .butt
		
		return fullPath
	}
	
	private func pathForBottomRightCorner(fittingSize size: CGSize) -> UIBezierPath {
		let path = genericTopLeftCorner(armLength: armLength, lineWidth: lineWidth)
		let rotation = CGAffineTransform(rotationAngle: .pi)
		let translation = CGAffineTransform(translationX: size.width, y: size.height)
		let transform = rotation.concatenating(translation)
		path.apply(transform)
		return path
	}
	
	private func pathForTopRightCorner(fittingSize size: CGSize) -> UIBezierPath {
		let path = genericTopLeftCorner(armLength: armLength, lineWidth: lineWidth)
		let rotation = CGAffineTransform(rotationAngle: .pi / 2.0)
		let translation = CGAffineTransform(translationX: size.width, y: 0)
		let transform = rotation.concatenating(translation)
		path.apply(transform)
		return path
	}
	
	private func pathForTopLeftCorner(fittingSize size: CGSize) -> UIBezierPath {
		return genericTopLeftCorner(armLength: armLength, lineWidth: lineWidth)
	}
	
	private func pathForBottomLeftCorner(fittingSize size: CGSize) -> UIBezierPath {
		let path = genericTopLeftCorner(armLength: armLength, lineWidth: lineWidth)
		let rotation = CGAffineTransform(rotationAngle: -.pi / 2.0)
		let translation = CGAffineTransform(translationX: 0, y: size.height)
		let transform = rotation.concatenating(translation)
		path.apply(transform)
		return path
	}
	
	/// Draws a single corner for the top left of a rectangle. The point of the corner will be at (0,0).
	///
	/// - Parameters:
	///   - armLength: the length of the arms of the corner, currently each arm will be equal
	///   - lineWidth: the width of the line or strokewidth. this is used for calculations of layout.
	/// - Returns: a bezier path ready to go!
	private func genericTopLeftCorner(armLength: CGFloat, lineWidth: CGFloat) -> UIBezierPath {
		let lineWidth_2 = lineWidth / 2.0
		let path = UIBezierPath()
		path.move(to: CGPoint(x: armLength, y: lineWidth_2))
		path.addLine(to: CGPoint(x: lineWidth_2, y: lineWidth_2))
		path.addLine(to: CGPoint(x: lineWidth_2, y: armLength))
		return path
	}
	
	public override var intrinsicContentSize: CGSize {
		return crossHairSize
	}
	
}
