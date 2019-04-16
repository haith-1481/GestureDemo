//
//  ViewController.swift
//  UIRecognizerDemo
//
//  Created by trinh.hoang.hai on 4/16/19.
//  Copyright © 2019 trinh.hoang.hai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var notiLabel: UILabel!

    var initialCenter = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))

        for gesture in [tapGesture, pinchGesture, rotationGesture, swipeGesture, panGesture, screenEdgePanGesture, longPressGesture] {
            orangeView.addGestureRecognizer(gesture)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer)
        return true
    }

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.view != nil else { return }

        if recognizer.state == .ended {      // Move the view down and to the right when tapped.
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
                recognizer.view!.center.x += 10
                recognizer.view!.center.y += 10
            })
            animator.startAnimation()
        notiLabel.text = "Tapped"
        }
    }

    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            orangeView.transform = orangeView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1.0
            notiLabel.text = "pinched"
        }
    }

    @objc func handleRotation(_ recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            orangeView.transform = orangeView.transform.rotated(by: recognizer.rotation)
            notiLabel.text = "Rotated"
        }
    }

    @objc func handleSwipe(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            // Perform action.
            notiLabel.text = "Swiped"
        }
    }

    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else {return}
        let piece = recognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = recognizer.translation(in: piece.superview)
        if recognizer.state == .began {
            // Save the view's original position.
            self.initialCenter = piece.center
        }
        // Update the position for the .began, .changed, and .ended states
        if recognizer.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        }
        else {
            // On cancellation, return the piece to its original location.
            piece.center = initialCenter
        }
        notiLabel.text = "Pan"
    }

    @objc func handleScreenEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        notiLabel.text = "EdgePan"
        print(recognizer.edges)
    }

    @objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        notiLabel.text = "Long pressed"
    }

}
