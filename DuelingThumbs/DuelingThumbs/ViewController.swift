//
//  ViewController.swift
//  DuelingThumbs
//
//  Created by Don Mag on 3/21/18.
//  Copyright © 2018 DonMag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	
	@IBOutlet var leftThumbView: UIImageView!
	@IBOutlet var rightThumbView: UIImageView!
	@IBOutlet var centerThumbView: UIImageView!

	@IBOutlet var leftCenterXConstraint: NSLayoutConstraint!
	@IBOutlet var rightCenterXConstraint: NSLayoutConstraint!
	@IBOutlet var centerCenterXConstraint: NSLayoutConstraint!

	@IBOutlet var centerLeftConstraint: NSLayoutConstraint!
	@IBOutlet var centerRightConstraint: NSLayoutConstraint!

	
	var leftPanGesture  = UIPanGestureRecognizer()
	var rightPanGesture  = UIPanGestureRecognizer()
	var centerPanGesture  = UIPanGestureRecognizer()

	var leftThumbCurrentCenterXConstant: CGFloat = 0.0
	var rightThumbCurrentCenterXConstant: CGFloat = 0.0
	var centerThumbCurrentCenterXConstant: CGFloat = 0.0
	
	var currentCenterXConstant: CGFloat = 0.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
		rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
		centerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))

		leftThumbView.isUserInteractionEnabled = true
		leftThumbView.addGestureRecognizer(leftPanGesture)
		
		rightThumbView.isUserInteractionEnabled = true
		rightThumbView.addGestureRecognizer(rightPanGesture)
		
		centerThumbView.isUserInteractionEnabled = true
		centerThumbView.addGestureRecognizer(centerPanGesture)
		
		centerThumbView.isHidden = true
	}
	
	@objc func panGestureHandler(_ recognizer: UIPanGestureRecognizer){
		
		guard let vActive = recognizer.view as? UIImageView else { return }
		
		switch recognizer.state {
		case .began:
			self.view.bringSubview(toFront: vActive)
			if vActive == leftThumbView {
				leftCenterXConstraint.priority = .defaultLow
				rightCenterXConstraint.priority = .defaultHigh
				currentCenterXConstant = leftCenterXConstraint.constant
				centerLeftConstraint.priority = .init(1.0)
				centerRightConstraint.priority = .init(1.0)
				centerCenterXConstraint.priority = .defaultHigh
			} else if vActive == rightThumbView {
				leftCenterXConstraint.priority = .defaultHigh
				rightCenterXConstraint.priority = .defaultLow
				currentCenterXConstant = rightCenterXConstraint.constant
				centerLeftConstraint.priority = .init(1.0)
				centerRightConstraint.priority = .init(1.0)
				centerCenterXConstraint.priority = .defaultHigh
			} else {
				leftCenterXConstraint.priority = .init(1.0)
				rightCenterXConstraint.priority = .init(1.0)
				centerLeftConstraint.priority = .defaultHigh
				centerRightConstraint.priority = .defaultHigh
				centerCenterXConstraint.priority = .defaultLow
				currentCenterXConstant = centerCenterXConstraint.constant
			}
			break
			
		case .changed:
			let translation = recognizer.translation(in: self.view)
			if vActive == leftThumbView {
				leftCenterXConstraint.constant = currentCenterXConstant + translation.x
				centerThumbView.isHidden = rightThumbView.frame.origin.x - (leftThumbView.frame.origin.x + leftThumbView.frame.size.width) > 0
				centerCenterXConstraint.constant = rightCenterXConstraint.constant - (centerThumbView.frame.size.width / 2.0)
			} else if vActive == rightThumbView {
				rightCenterXConstraint.constant = currentCenterXConstant + translation.x
				centerThumbView.isHidden = rightThumbView.frame.origin.x - (leftThumbView.frame.origin.x + leftThumbView.frame.size.width) > 0
				centerCenterXConstraint.constant = leftCenterXConstraint.constant + (centerThumbView.frame.size.width / 2.0)
			} else {
				centerCenterXConstraint.constant = currentCenterXConstant + translation.x
			}
			break
			
		case .ended, .cancelled:
			leftCenterXConstraint.constant = leftThumbView.center.x - view.center.x
			rightCenterXConstraint.constant = rightThumbView.center.x - view.center.x
			centerCenterXConstraint.constant = centerThumbView.center.x - view.center.x
			centerThumbView.isHidden = rightThumbView.frame.origin.x - (leftThumbView.frame.origin.x + leftThumbView.frame.size.width) > 0
			break
			
		default:
			break
		}
		
	}
	
}
