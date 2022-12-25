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
    private var allTime = Time.workTime {
        didSet {
            print(allTime)
        }
    }

    private var isWorkTime: Bool = true
    private var isStarted: Bool = false
    private var isAnimationStarted: Bool = false

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
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

//    private lazy var cancelButton: UIButton = {
//        var configuration = UIButton.Configuration.tinted()
//        configuration.cornerStyle = .capsule
//        configuration.baseBackgroundColor = Colors.gray
//        configuration.baseForegroundColor = UIColor.white
//        configuration.buttonSize = .large
//        configuration.image = UIImage(systemName: "goforward")
//        configuration.titleAlignment = .leading
//
//        let button = UIButton(configuration: configuration)
//        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var stack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.alignment = .center
//        stack.distribution = .fillEqually
//        stack.spacing = 40
//        stack.addArrangedSubview(cancelButton)
//        stack.addArrangedSubview(playAndPauseButton)
//        return stack
//    }()

    // MARK: - Leficycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.black
        setupHierarchy()
        setupLayout()
        createCircularPath()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        view.addSubviews([
            titleLabel,
            countdownTimeLabel,
            playAndPauseButton
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
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-80)
        }
//
//        cancelButton.snp.makeConstraints { make in
//            make.height.equalTo(80)
//            make.width.equalTo(80)
//        }
//
//        stack.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.width.equalTo(200)
//            make.bottom.equalTo(view).offset(-80)
//        }
    }
    //Метод для перевода в минуты и секунды
    private func setupTime() {
        let minutes = Int(allTime) / 60 % 60
        let seconds = Int(allTime) % 60
        countdownTimeLabel.text = String(format: "%02i:%02i", minutes, seconds)
    }

    // MARK: - Circle Progress Bar

    //Метод создания таймлайна - серая подложка
    private func createCircularPath() {
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0), radius: 130, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        circleLayer.strokeColor = Colors.gray.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 15
        circleLayer.strokeEnd = 1.0
        view.layer.addSublayer(circleLayer)
    }

    //Метод создания таймлайна - бегущий прогресс бар
    private func createProgressLayerPath() {
        progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0), radius: 130, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        progressLayer.lineWidth = 15
        progressLayer.strokeEnd = 0.0
        progressLayer.lineCap = .round
        progressLayer.fillColor = UIColor.clear.cgColor
        guard isWorkTime else {
            return progressLayer.strokeColor = Colors.green.cgColor
        }
        progressLayer.strokeColor = Colors.blue.cgColor
        view.layer.addSublayer(progressLayer)
    }

    //Метод режима работы анимации
    private func startResumeAnimation() {
        if isAnimationStarted == false {
            startAnimation()
        } else {
            resumeAnimation(for: progressLayer)
        }
    }

    //Метод для настройки старта анимации
    private func startAnimation() {
        resetAnimation()
        isAnimationStarted = true
        progressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0.0
        animation.duration = CFTimeInterval(allTime)
        animation.toValue = 1.0
        animation.fillMode = .forwards
        animation.isAdditive = true
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnim")
    }

    //Метод настройки для перезагрузки анимации
    private func resetAnimation() {
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }

    //Метод настройки для паузы анимации
    private func pauseAnimation(for circle: CAShapeLayer) {
        let pauseTime = circle.convertTime(CACurrentMediaTime(), from: nil)
        circle.speed = 0.0
        circle.timeOffset = pauseTime
    }

    //Метод настройки для продолжения анимации
    private func resumeAnimation(for circle: CAShapeLayer) {
        let pauseTime = circle.timeOffset
        circle.speed = 1.0
        circle.timeOffset = 0.0
        circle.beginTime = 0.0
        let timeSincePaused = circle.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        circle.beginTime = timeSincePaused
    }

    //Метод настройки для остановки анимации
    private func stopAnimation() {
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        isAnimationStarted = false
    }

    // MARK: - Actions

    //Метод режима кнопки работы старт и паузы
    @objc private func startAndPauseButtonTapped() {
//        cancelButton.isEnabled = true

        if isStarted == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerMode), userInfo: nil, repeats: true)
            startResumeAnimation()
            createProgressLayerPath()
            playAndPauseButton.configuration?.image = UIImage(systemName: "pause.fill")
            playAndPauseButton.configuration?.baseBackgroundColor = Colors.red
            isStarted = true
            print("start")
        } else {
            timer.invalidate()
            pauseAnimation(for: progressLayer)
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
            playAndPauseButton.configuration?.baseBackgroundColor = Colors.green
            isStarted = false
            print("pause")
        }
    }

    //Метод установки режима работы в зависимости от таймера
    @objc private func timerMode() {
        allTime -= 1
        countdownTimeLabel.text = "\(allTime)"
        setupTime()

        //Режим отдыха и работы
        if allTime == 0 && isWorkTime == true {
            stopAnimation()
            allTime = Time.breakTime
            animation.duration = CFTimeInterval(allTime)
            titleLabel.text = "Relax"
            countdownTimeLabel.text = "00:05"
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
//            cancelButton.isEnabled = false
            isStarted = false
            isWorkTime = false
            timer.invalidate()
        } else if allTime == 0 && isWorkTime == false {
            allTime = Time.breakTime
            animation.duration = CFTimeInterval(allTime)
            titleLabel.text = "Work"
            countdownTimeLabel.text = "00:10"
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
            stopAnimation()
//            cancelButton.isEnabled = false
            isStarted = false
            isWorkTime = true
            timer.invalidate()
        }
    }

//    //Метод режима кнопки рефреш
//    @objc private func cancelButtonTapped() {
//        stopAnimation()
//        cancelButton.isEnabled = false
//        isStarted = false
//        isWorkTime = true
//        allTime = Time.workTime
////        workingTime = 10
////        relaxTime = 5
//        timer.invalidate()
//        countdownTimeLabel.text = "00:10"
//        titleLabel.text = "Work"
//        playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
//    }
}


extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}

extension ViewController {
    enum Time {
        static let workTime = 10
        static let breakTime = 5
    }
}
