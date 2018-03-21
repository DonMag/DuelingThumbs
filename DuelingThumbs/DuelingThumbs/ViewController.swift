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
	
	@IBOutlet var leftCenterXConstraint: NSLayoutConstraint!
	@IBOutlet var rightCenterXConstraint: NSLayoutConstraint!
	
	var leftPanGesture  = UIPanGestureRecognizer()
	var rightPanGesture  = UIPanGestureRecognizer()
	
	var leftThumbCurrentCenterXConstant: CGFloat = 0.0
	var rightThumbCurrentCenterXConstant: CGFloat = 0.0
	
	var currentCenterXConstant: CGFloat = 0.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
		rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(_:)))
		
		leftThumbView.isUserInteractionEnabled = true
		leftThumbView.addGestureRecognizer(leftPanGesture)
		
		rightThumbView.isUserInteractionEnabled = true
		rightThumbView.addGestureRecognizer(rightPanGesture)
		
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
			} else {
				leftCenterXConstraint.priority = .defaultHigh
				rightCenterXConstraint.priority = .defaultLow
				currentCenterXConstant = rightCenterXConstraint.constant
			}
			break
			
		case .changed:
			let translation = recognizer.translation(in: self.view)
			if vActive == leftThumbView {
				leftCenterXConstraint.constant = currentCenterXConstant + translation.x
			} else {
				rightCenterXConstraint.constant = currentCenterXConstant + translation.x
			}
			break
			
		case .ended, .cancelled:
			if vActive == leftThumbView {
				leftCenterXConstraint.constant = leftThumbView.center.x - view.center.x
			} else {
				rightCenterXConstraint.constant = rightThumbView.center.x - view.center.x
			}
			break
			
		default:
			break
		}
		
	}
	
}
