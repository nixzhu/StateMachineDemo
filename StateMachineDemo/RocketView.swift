//
//  RocketView.swift
//  StateMachineDemo
//
//  Created by NIX on 15/4/22.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import UIKit

@IBDesignable
class RocketView: UIView {

    @IBInspectable
    var countDown: Int = 10 {
        willSet {
            countDownLabel.text = "\(newValue)"
        }

        didSet {
            println("countDown \(countDown)")
        }
    }

    var fireTimer: NSTimer?

    func makeNewFireTimer() -> NSTimer {
        //let timer = NSTimer(timeInterval: 1, target: self, selector: "countDownToFire:", userInfo: nil, repeats: true)
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDownToFire:", userInfo: nil, repeats: true)
        return timer
    }

    lazy var countDownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.text = "\(self.countDown)"
        label.font = UIFont.boldSystemFontOfSize(30)
        label.backgroundColor = UIColor.whiteColor()
        return label
        }()

    lazy var fireButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fire", forState: .Normal)
        button.backgroundColor = UIColor.redColor()
        button.layer.cornerRadius = 10

        button.addTarget(self, action: "tryFire", forControlEvents: .TouchUpInside)

        return button
        }()

    lazy var abortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Abort", forState: .Normal)
        button.backgroundColor = UIColor.greenColor()
        button.layer.cornerRadius = 10

        button.addTarget(self, action: "abort", forControlEvents: .TouchUpInside)

        return button
        }()


    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        makeUI()
    }

    func makeUI() {
        addSubview(countDownLabel)
        addSubview(fireButton)
        addSubview(abortButton)

        countDownLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        fireButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        abortButton.setTranslatesAutoresizingMaskIntoConstraints(false)

        let viewsDictionary = [
            "countDownLabel": countDownLabel,
            "fireButton": fireButton,
            "abortButton": abortButton,
        ]

        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=0)-[countDownLabel(50)]-30-[fireButton(60)]-|", options: NSLayoutFormatOptions(0) , metrics: nil, views: viewsDictionary)

        let constraintsH1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[countDownLabel]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)

        let constraintsH2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[fireButton]-[abortButton(==fireButton)]-|", options: .AlignAllCenterY | .AlignAllTop | .AlignAllBottom, metrics: nil, views: viewsDictionary)

        NSLayoutConstraint.activateConstraints(constraintsV)
        NSLayoutConstraint.activateConstraints(constraintsH1)
        NSLayoutConstraint.activateConstraints(constraintsH2)
    }

    // MARK: Actions

    func tryFire() {
        countDown = 10

        fireTimer = makeNewFireTimer()
    }

    func abort() {
        fireTimer?.invalidate()

        countDown = 10
    }

    func countDownToFire(timer: NSTimer) {

        countDown--

        if (countDown == 0) {
            fireTimer?.invalidate()

            println("fire")
        }
    }

}
