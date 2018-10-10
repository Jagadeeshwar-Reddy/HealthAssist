//
//  CardAnimator.swift
//  Mario
//
//  Created by Jon Hocking on 16/01/2018.
//  Copyright © 2018 Tesco. All rights reserved.
//

import Foundation
import UIKit

public final class CardAnimator: Animator {
	
	private let cardViewToPresent: UIView
	private let presentingView: UIView
	private let supplementaryView: UIView

	required public init(viewToAnimate: UIView, presentingView: UIView, supplementaryView: UIView) {
		self.cardViewToPresent = viewToAnimate
		self.presentingView = presentingView
		self.supplementaryView = supplementaryView
	}
	
	public func present(duration: TimeInterval = 0.38, completion: AnimatorCompletion? = nil) {
		cardViewToPresent.isHidden = false
		cardViewToPresent.layoutIfNeeded()
		
		guard let viewToTransition = cardViewToPresent.snapshotView(afterScreenUpdates: true) else {
			return
		}
		presentingView.isUserInteractionEnabled = false
		presentingView.insertSubview(viewToTransition, aboveSubview: cardViewToPresent)
		viewToTransition.frame = cardViewToPresent.frame
		cardViewToPresent.isHidden = true
		
		let beginMinYPosition = presentingView.bounds.maxY
		let finalMinYPosition = viewToTransition.frame.minY

		let yDiff = finalMinYPosition - beginMinYPosition
		let transform = CGAffineTransform(translationX: 0, y: -yDiff)
		viewToTransition.transform = transform
		
		let propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: TimingCurve.onOffScreen)
		propertyAnimator.isUserInteractionEnabled = false
		propertyAnimator.addAnimations {
			viewToTransition.transform = .identity
		}

		propertyAnimator.addCompletion { (_) in
			viewToTransition.removeFromSuperview()
			self.cardViewToPresent.isHidden = false
			self.presentingView.isUserInteractionEnabled = true
			completion?()
		}

		let supplementaryAnimator = UIViewPropertyAnimator(duration: propertyAnimator.duration, curve: .easeInOut) {
			self.supplementaryView.alpha = 1
		}
		supplementaryAnimator.isUserInteractionEnabled = false
		
		supplementaryAnimator.startAnimation()
		propertyAnimator.startAnimation()
		
	}
	
	public func dismiss(duration: TimeInterval = 0.48, completion: AnimatorCompletion? = nil) {
		
		cardViewToPresent.isHidden = false
		
		guard let viewToTransition = cardViewToPresent.snapshotView(afterScreenUpdates: true) else { return }
		presentingView.isUserInteractionEnabled = false
		presentingView.insertSubview(viewToTransition, aboveSubview: cardViewToPresent)
		viewToTransition.frame = cardViewToPresent.frame
		
		cardViewToPresent.isHidden = true
		
		let beginMinYPosition = viewToTransition.frame.minY
		let finalMinYPosition = presentingView.bounds.maxY

		let yDiff = finalMinYPosition - beginMinYPosition
		let finalTransform = CGAffineTransform(translationX: 0, y: yDiff)

		let propertyAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: TimingCurve.onOffScreen)
		propertyAnimator.isUserInteractionEnabled = false
		propertyAnimator.addAnimations {
			viewToTransition.transform = finalTransform
		}
		
		propertyAnimator.addCompletion { (_) in
			viewToTransition.removeFromSuperview()
			self.presentingView.isUserInteractionEnabled = true
			completion?()
		}

		let supplementaryAnimator = UIViewPropertyAnimator(duration: propertyAnimator.duration, curve: .easeInOut) {
			self.supplementaryView.alpha = 0
		}
		supplementaryAnimator.isUserInteractionEnabled = false
		
		supplementaryAnimator.startAnimation()
		propertyAnimator.startAnimation()
	}
	
}
