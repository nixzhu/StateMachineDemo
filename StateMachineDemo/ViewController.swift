//
//  ViewController.swift
//  StateMachineDemo
//
//  Created by NIX on 15/4/22.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rocketView: RocketView!
    @IBOutlet weak var rocketViewBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        rocketView.stateTransitionAction = { (previousState, currentState) in

            println("state from \(previousState) to \(currentState)")

            switch (previousState, currentState) {

            case (.CountDown, .Launch):
                UIView.animateWithDuration(3.0, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.rocketViewBottomConstraint.constant = CGRectGetHeight(self.view.bounds)
                    self.view.layoutIfNeeded()

                }, completion: { (finished) -> Void in
                })
                
            default:
                break
            }
        }
    }
}

