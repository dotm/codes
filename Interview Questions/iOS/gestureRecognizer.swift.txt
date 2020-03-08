//
//  ViewController.swift
//  gesture-recognizers
//
//  Created by Yoshua Elmaryono on 13/08/18.
//  Copyright © 2018 Yoshua Elmaryono. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    weak var text: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup status label
        let frame = CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height)
        let text = UITextView(frame: frame)
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 32)
        text.isUserInteractionEnabled = false
        text.text = "Hello"
        view.addSubview(text)
        self.text = text
        
        // Setup gesture recognizers
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRootView))
        tapRecognizer.numberOfTouchesRequired = 2
        tapRecognizer.numberOfTapsRequired = 3
        view.addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRootView))
        longPressRecognizer.allowableMovement = CGFloat(10)
        longPressRecognizer.minimumPressDuration = 3
        longPressRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(longPressRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRootView))
        swipeRecognizer.direction = .up
        swipeRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(swipeRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchRootView))
        view.addGestureRecognizer(pinchRecognizer)
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateRootView))
        view.addGestureRecognizer(rotationRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRootView))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
//        view.addGestureRecognizer(panRecognizer)
        
        let screenEdgePanRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgePanRootView))
        screenEdgePanRecognizer.edges = UIRectEdge.right
        screenEdgePanRecognizer.minimumNumberOfTouches = 1
        view.addGestureRecognizer(screenEdgePanRecognizer)
    }
    
    @objc func tapRootView(_ gesture: UITapGestureRecognizer){
        var string = "You just tap the root view \(gesture.numberOfTapsRequired) time(s) with \(gesture.numberOfTouches) finger(s)."
        for index in 0..<gesture.numberOfTouches {
            let location = gesture.location(ofTouch: index, in: gesture.view)
            string += "\n"
            string += "Touch number \(index + 1) is at \(location)."
        }
        text.text = string
    }
    
    @objc func longPressRootView(_ gesture: UITapGestureRecognizer){
        var string = "You just long press the root view with \(gesture.numberOfTouches) finger(s)."
        for index in 0..<gesture.numberOfTouches {
            let location = gesture.location(ofTouch: index, in: gesture.view)
            string += "\n"
            string += "Touch number \(index + 1) is at \(location)."
        }
        text.text = string
    }
    
    @objc func swipeRootView(_ gesture: UISwipeGestureRecognizer){
        var string = "You just swipe the root view with \(gesture.numberOfTouches) finger(s)."
        for index in 0..<gesture.numberOfTouches {
            let location = gesture.location(ofTouch: index, in: gesture.view)
            string += "\n"
            string += "Swipe number \(index + 1) begins at \(location)."
        }
        text.text = string
    }

    @objc func pinchRootView(_ gesture: UIPinchGestureRecognizer){
        let string = """
            You just pinch the root view.
            Scale: \(gesture.scale)
            Velocity: \(gesture.velocity)
            """
        text.text = string
    }
    
    @objc func rotateRootView(_ gesture: UIRotationGestureRecognizer){
        let string = """
        You just rotate the root view.
        Rotation: \(gesture.rotation)
        Velocity: \(gesture.velocity)
        """
        text.text = string
    }
    
    @objc func panRootView(_ gesture: UIPanGestureRecognizer){
        var string = "You just pan the root view with \(gesture.numberOfTouches) finger(s)."
        string += "\nPan \(gesture.state.rawValue) with"
        string += "\nTranslation: \(gesture.translation(in: view))"
        string += "\nVelocity: \(gesture.velocity(in: view))"
        for index in 0..<gesture.numberOfTouches {
            let location = gesture.location(ofTouch: index, in: gesture.view)
            string += "\n"
            string += "Touch number \(index + 1) is at \(location)."
        }
        text.text = string
    }
    
    @objc func screenEdgePanRootView(_ gesture: UIScreenEdgePanGestureRecognizer){
        var string = "You just pan the root view from screen edge \(gesture.edges) with \(gesture.numberOfTouches) finger(s)."
        string += "\nPan \(gesture.state.rawValue) with"
        string += "\nTranslation: \(gesture.translation(in: view))"
        string += "\nVelocity: \(gesture.velocity(in: view))"
        for index in 0..<gesture.numberOfTouches {
            let location = gesture.location(ofTouch: index, in: gesture.view)
            string += "\n"
            string += "Touch number \(index + 1) is at \(location)."
        }
        text.text = string
    }
}

