//
//  HeartButton.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 23.10.2021.
//

import Foundation
import UIKit

class LikeButton: UIButton {

    private var progress: CGFloat = 0.0
    private var step: CGFloat = 0.0
    private var target: CGFloat = 1.0
    private var isLiked = false
    private let unlikedImage = UIImage(named: "heart.svg")
    private let likedImage = UIImage(named: "heart-fill-red.svg")
    private let heartLayer = CALayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setImage(unlikedImage, for: .normal)
        self.addTarget(self, action: #selector(flipLikedState), for: .touchUpInside)

        heartLayer.contents = likedImage?.cgImage
        layer.addSublayer(heartLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        heartLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    public func setProgress(_ progressToApply: CGFloat) {
        let targetBounds = CGRect(x: 0, y: 0, width: bounds.width * progressToApply, height: bounds.height * progressToApply)
        heartLayer.bounds = targetBounds
        progress = progressToApply
    }

    @objc private func flipLikedState() {
        isLiked.toggle()

        if isLiked {
            step = 0.04
            target = 1.0
        } else {
            step = -0.04
            target = 0
        }
        startLoadingAnimation()
    }

    private func startLoadingAnimation() {
        let timer = Timer.scheduledTimer(timeInterval: 0.03,
                                         target: self,
                                         selector: #selector(handleTimerAction),
                                         userInfo: time,
                                         repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
    }

    @objc
    private func handleTimerAction(sender: Timer) {
        if abs(progress - target) <= 0.01 {
            sender.invalidate()
            triggerCompletion()
        } else {
            setProgress(progress + step)
        }
    }

    private func triggerCompletion() {
        setProgress(target)
    }
}
