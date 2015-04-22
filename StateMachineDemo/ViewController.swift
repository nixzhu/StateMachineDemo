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

    @IBOutlet weak var landingButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        landingButton.enabled = false

        rocketView.stateTransitionAction = { (previousState, currentState) in

            println("state from \(previousState) to \(currentState)")

            switch (previousState, currentState) {

            case (.CountDown, .Launch):
                UIView.animateWithDuration(3.0, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                    self.rocketViewBottomConstraint.constant = CGRectGetHeight(self.view.bounds)
                    self.view.layoutIfNeeded()

                }, completion: { (finished) -> Void in
                    self.landingButton.enabled = true
                })
                
            default:
                if currentState == .Standby {
                    self.landingButton.enabled = false

                    UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                        self.rocketViewBottomConstraint.constant = 20
                        self.view.layoutIfNeeded()

                    }, completion: { (finished) -> Void in
                    })
                }
            }
        }
    }

    @IBAction func landing(sender: UIBarButtonItem) {
        rocketView.currentState = .Standby
    }
}

