//
//  ViewController.swift
//  TomatoMethodApp
//
//  Created by Kristina Korotkova on 23/12/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private var timer = Timer()
    private var workingTime = 10
    private var relaxTime = 5

    private var isWorkTime: Bool = true
    private var isStarted: Bool = false
    private var isAnimationStarted: Bool = false

    private let foreProgressLayer = CAShapeLayer()
    private let backProgressLayer = CAShapeLayer()
    private let animation = CABasicAnimation(keyPath: "strokeEnd")

    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Work"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        return label
    }()

    private lazy var countdownTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        label.textColor = .white
        return label
    }()

    private lazy var playAndPauseButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = Colors.green
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .large
        configuration.image = UIImage(systemName: "play.fill")
        configuration.titleAlignment = .leading

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(startAndPauseButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = Colors.gray
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .large
        configuration.image = UIImage(systemName: "goforward")
        configuration.titleAlignment = .leading

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 40
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(playAndPauseButton)
        return stack
    }()

    // MARK: - Leficycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.black
        setupHierarchy()
        setupLayout()
        drawBackLayer()
        drawForeLayer()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        view.addSubviews([
            titleLabel,
            countdownTimeLabel,
            stack
        ])
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(100)
            make.centerX.equalTo(view)
        }

        countdownTimeLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }

        playAndPauseButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }

        stack.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.bottom.equalTo(view).offset(-80)
        }
    }

    private func formatWorkTimer() -> String {
        let minutes = Int(workingTime) / 60 % 60
        let seconds = Int(workingTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    private func formatRelaxTimer() -> String {
        let minutes = Int(relaxTime) / 60 % 60
        let seconds = Int(relaxTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {
        if isWorkTime {
            updateWork()
        } else {
            updateRelax()
        }
    }

    private func updateWork() {
        if workingTime == 0 {
            stopAnimation()
            cancelButton.isEnabled = false
            isStarted = false
            isWorkTime = false
            workingTime = 10
            timer.invalidate()
            titleLabel.text = "Relax"
            countdownTimeLabel.text = "00:05"
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        } else {
            workingTime -= 1
            countdownTimeLabel.text = formatWorkTimer()
        }
    }

    private func updateRelax() {
        if relaxTime < 1 {
            stopAnimation()
            cancelButton.isEnabled = false
            isStarted = false
            isWorkTime = true
            relaxTime = 5
            timer.invalidate()
            titleLabel.text = "Work"
            countdownTimeLabel.text = "00:10"
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        } else {
            relaxTime -= 1
            countdownTimeLabel.text = formatRelaxTimer()
        }
    }

    private func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0), radius: 130, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        backProgressLayer.strokeColor = Colors.gray.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 15
        view.layer.addSublayer(backProgressLayer)
    }

    private func drawForeLayer() {
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0), radius: 130, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        foreProgressLayer.lineWidth = 15
        foreProgressLayer.lineCap = .round
        foreProgressLayer.fillColor = UIColor.clear.cgColor

        if isWorkTime {
            foreProgressLayer.strokeColor = Colors.blue.cgColor
        } else {
            foreProgressLayer.strokeColor = Colors.green.cgColor
        }

        view.layer.addSublayer(foreProgressLayer)
    }

    private func startResumeAnimation() {
        if isAnimationStarted {
            resumeAnimation()
        } else {
            startAnimation()
        }
    }

    private func startAnimation() {
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = .forwards

        if isWorkTime {
            animation.duration = CFTimeInterval(workingTime)
        } else {
            animation.duration = CFTimeInterval(relaxTime)
        }

        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    private func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }

    private func pauseAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), to: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }

    private func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0

        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), to: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }

    private func stopAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }

    // MARK: - Actions

    @objc private func startAndPauseButtonTapped() {
        cancelButton.isEnabled = true

        if isStarted {
            isStarted = false
            timer.invalidate()
            pauseAnimation()
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
            playAndPauseButton.configuration?.baseBackgroundColor = Colors.green
        } else {
            isStarted = true
            timer.invalidate()
            drawForeLayer()
            startResumeAnimation()
            playAndPauseButton.configuration?.image = UIImage(systemName: "pause.fill")
            playAndPauseButton.configuration?.baseBackgroundColor = Colors.red
            startTimer()
        }
    }

    @objc private func cancelButtonTapped() {
        stopAnimation()
        cancelButton.isEnabled = false
        isStarted = false
        isWorkTime = true
        workingTime = 10
        relaxTime = 5
        timer.invalidate()
        countdownTimeLabel.text = "00:10"
        titleLabel.text = "Work"
        playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
    }
}

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
