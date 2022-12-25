//
//  ViewController.swift
//  TomatoMethodApp
//
//  Created by Kristina Korotkova on 23/12/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Properties

    private var timer = Timer()
    private var workTime: TimeInterval = 10
    private var relaxTime: TimeInterval = 5
    private var accurateTimerCount = 1000

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    private var isWorkTime = true
    private var isStarted = false
    private var isAnimationStarted = false

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
        label.text = "00:10"
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

    private lazy var refreshButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = Colors.gray
        configuration.baseForegroundColor = UIColor.white
        configuration.buttonSize = .large
        configuration.image = UIImage(systemName: "goforward")
        configuration.titleAlignment = .leading

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 40
        stack.addArrangedSubview(refreshButton)
        stack.addArrangedSubview(playAndPauseButton)
        return stack
    }()

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

        refreshButton.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }

        stack.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.width.equalTo(200)
            make.bottom.equalTo(view).offset(-80)
        }
    }

    // MARK: - Progress bar

    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0), radius: 140, startAngle: startPoint, endAngle: endPoint, clockwise: true)

        //Создание фона круга
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 15
        circleLayer.strokeEnd = 1
        circleLayer.strokeColor = Colors.gray.cgColor
        view.layer.addSublayer(circleLayer)

        //Создание прогресс бара
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 15
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = Colors.blue.cgColor
        view.layer.addSublayer(progressLayer)
    }

    //Метод режима работы анимации
    private func startResumeAnimation() {
        if !isAnimationStarted{
            changeTime()
        } else {
            resumeAnimation(for: progressLayer)
            print("resumeAnimation")
        }
    }

    //Метод меняет время, в зависимоти от рабочего времени
    private func changeTime() {
        if isWorkTime {
            startAnimation(duration: workTime)
            print("workTime")
        } else {
            startAnimation(duration: relaxTime)
            print("relaxTime")
        }
    }

    //Метод для настройки старта анимации
    private func startAnimation(duration: TimeInterval) {
        resetAnimation()
        isAnimationStarted = true
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }

    //Метод настройки для перезагрузки анимации
    private func resetAnimation() {
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        progressLayer.strokeEnd = 0.0
        isAnimationStarted = false
        print("resetAnimation")
    }

    //Метод настройки для паузы анимации
    private func pauseAnimation(for circle: CAShapeLayer) {
        let pauseTime = circle.convertTime(CACurrentMediaTime(), from: nil)
        circle.speed = 0.0
        circle.timeOffset = pauseTime
        print("pauseAnimation")
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
        print("stopAnimation")
    }

    // MARK: - Timer

    private func formatWorkTimer() -> String {
        let minutes = Int(workTime) / 60 % 60
        let seconds = Int(workTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    private func formatRelaxTimer() -> String {
        let minutes = Int(relaxTime) / 60 % 60
        let seconds = Int(relaxTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerMode), userInfo: nil, repeats: true)
    }

    //Метод установки режима таймера
    @objc private func timerMode() {
        if accurateTimerCount > 0 {
            accurateTimerCount -= 1
            return
        }

        accurateTimerCount = 1000

        if isWorkTime {
            changeToRelax()
        } else {
            changeToWork()
        }
    }

    //Интерфейс для работы
    private func workTimeInterface() {
        titleLabel.text = "Work"
        countdownTimeLabel.text = "00:10"
        playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        progressLayer.strokeColor = Colors.blue.cgColor
    }

    //Интерфейс для отдыха
    private func relaxTimeInterface() {
        titleLabel.text = "Relax"
        countdownTimeLabel.text = "00:05"
        playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        progressLayer.strokeColor = Colors.green.cgColor
    }

    //Режим рабочее время и сменя на отдых
    private func changeToRelax() {
        guard workTime > 1 else {
            stopAnimation()
            workTime = 10
            relaxTimeInterface()
            isStarted = false
            isWorkTime = false
            refreshButton.isEnabled = false
            timer.invalidate()
            print("work stop")
            return
        }

        print("work go \(workTime)")
        workTime -= 1
        countdownTimeLabel.text = formatWorkTimer()
    }

    //Режим отдыха и сменя на рабочее время
    private func changeToWork() {
        guard relaxTime > 1 else {
            stopAnimation()
            relaxTime = 5
            workTimeInterface()
            isStarted = false
            isWorkTime = true
            refreshButton.isEnabled = false
            timer.invalidate()
            print("relax stop")
            return
        }

        print("relax go \(relaxTime)")
        relaxTime -= 1
        countdownTimeLabel.text = formatRelaxTimer()
    }

    // MARK: - Actions

    //Метод режима кнопки работы старт и паузы
    @objc private func startAndPauseButtonTapped() {
        refreshButton.isEnabled = true

        if !isStarted {
            startTimer()
            startResumeAnimation()
            playAndPauseButton.configuration?.image = UIImage(systemName: "pause.fill")
            playAndPauseButton.configuration?.baseBackgroundColor = Colors.red
            isStarted = true
            print("start")
        } else {
            timer.invalidate()
            pauseAnimation(for: progressLayer)
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
            playAndPauseButton.configuration?.baseBackgroundColor = Colors.green
            progressLayer.removeAnimation(forKey: "progressAnimation")
            isStarted = false
            print("pause")
        }
    }

    @objc private func refreshButtonTapped() {
        stopAnimation()
        refreshButton.isEnabled = false
        isStarted = false
        isWorkTime = true
        workTime = 10
        relaxTime = 5
        accurateTimerCount = 1000
        timer.invalidate()
        workTimeInterface()
    }
}

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
