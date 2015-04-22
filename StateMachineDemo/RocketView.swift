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
    var countDown: Int = 5 {
        willSet {
            countDownLabel.text = "\(newValue)"
        }

        didSet {
            println("countDown \(countDown)")
        }
    }

    var fireTimer: NSTimer?

    func makeNewFireTimer() -> NSTimer {
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
        let button = UIButton.buttonWithType(.System) as! UIButton

        button.setTitle("Fire", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(20)

        button.backgroundColor = UIColor.redColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Disabled)
        button.layer.cornerRadius = 10

        button.addTarget(self, action: "fire", forControlEvents: .TouchUpInside)

        return button
        }()

    lazy var abortButton: UIButton = {
        let button = UIButton.buttonWithType(.System) as! UIButton
        
        button.setTitle("Abort", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(20)

        button.backgroundColor = UIColor.greenColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Disabled)
        button.layer.cornerRadius = 10

        button.addTarget(self, action: "abort", forControlEvents: .TouchUpInside)

        return button
        }()

    // MARK: 状态机

    // 所有必要的状态
    enum State: Printable {
        case Standby
        case CountDown
        case Launch

        var description: String {
            switch self {
            case .Standby:
                return "Standby"
            case .CountDown:
                return "CountDown"
            case .Launch:
                return "Launch"
            }
        }
    }

    // 前一个状态：根据具体需求，有可能不需要考虑前一个状态，就可以省去
    var previousState: State = .Standby

    // 当前状态
    var currentState: State = .Standby {
        willSet {
            // 先更新“之前”的状态（因为是 will，所以 currentState 还未改变）

            previousState = currentState

            // 再做一些状态改变之前要做的事情（可以 switch newValue 或 previousState 来做不同的操作)
            // ...
        }

        didSet {

            // 执行状态转换后操作

            if let stateTransitionAction = stateTransitionAction {
                stateTransitionAction(previousState: previousState, currentState: currentState)
            }

            // 还可以再做一些“内部”才关心的事情
            // ...

            switch currentState {
            case .Standby:
                fireTimer?.invalidate()

                countDown = 5

                countDownLabel.text = "\(currentState)"

                fireButton.enabled = true
                abortButton.enabled = false

            case .CountDown:
                countDown = 5

                fireTimer = makeNewFireTimer()

                fireButton.enabled = false
                abortButton.enabled = true

            case .Launch:
                fireTimer?.invalidate()

                countDownLabel.text = "\(currentState)"

                fireButton.enabled = false
                abortButton.enabled = false

            default:
                break
            }

        }
    }

    // 用闭包来将状态转换操作暴露给”外部“，外部可以利用状态的不同执行不同的操作
    var stateTransitionAction: ((previousState: State, currentState: State) -> Void)?


    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        makeUI()

        currentState = .Standby
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

    func fire() {
        currentState = .CountDown
    }

    func abort() {
        currentState = .Standby
    }

    func countDownToFire(timer: NSTimer) {

        countDown--

        if (countDown == 0) {
            currentState = .Launch
        }
    }

}
