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

    // MARK: - UI Elements

    private lazy var imageBackground: UIImageView = {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width: width, height: height))
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.center = view.center
        return imageView
    }()

    private lazy var countdownTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60, weight: .regular)
        label.textColor = .white
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Work"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        label.textColor = .white
        return label
    }()

    private lazy var playAndPauseButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Play"
        configuration.imagePadding = 20
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = UIColor.white
        configuration.baseForegroundColor = UIColor.black
        configuration.buttonSize = .large
        configuration.image = UIImage(systemName: "play.fill")
        configuration.titleAlignment = .leading

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(startAndPauseButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = "Cancel"
        configuration.imagePadding = 20
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = UIColor.white
        configuration.baseForegroundColor = UIColor.black
        configuration.buttonSize = .large
        configuration.image = UIImage(systemName: "multiply")
        configuration.titleAlignment = .leading

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Leficycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        view.addSubviews([
            imageBackground,
            titleLabel,
            countdownTimeLabel,
            playAndPauseButton,
            cancelButton
        ])
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(100)
            make.centerX.equalTo(view)
        }

        countdownTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(300)
            make.centerX.equalTo(view)
        }

        playAndPauseButton.snp.makeConstraints { make in
            make.top.equalTo(countdownTimeLabel.snp.bottom).offset(130)
            make.centerX.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }

        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(playAndPauseButton.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }

    func formatWorkTimer() -> String {
        let minutes = Int(workingTime) / 60 % 60
        let seconds = Int(workingTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    func formatRelaxTimer() -> String {
        let minutes = Int(relaxTime) / 60 % 60
        let seconds = Int(relaxTime) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if isWorkTime {
            updateWork()
        } else {
            updateRelax()
        }
    }

    func updateWork() {
        if workingTime < 1 {
            cancelButton.isEnabled = false
            isStarted = false
            isWorkTime = false
            workingTime = 10
            timer.invalidate()
            titleLabel.text = "Relax"
            countdownTimeLabel.text = "00:05"
            countdownTimeLabel.textColor = .red
            playAndPauseButton.configuration?.title = "Play"
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        } else {
            workingTime -= 1
            countdownTimeLabel.text = formatWorkTimer()
        }
    }

    func updateRelax() {
        if relaxTime < 1 {
            cancelButton.isEnabled = false
            isStarted = false
            isWorkTime = true
            relaxTime = 5
            timer.invalidate()
            titleLabel.text = "Work"
            countdownTimeLabel.text = "00:10"
            countdownTimeLabel.textColor = .white
            playAndPauseButton.configuration?.title = "Play"
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        } else {
            relaxTime -= 1
            countdownTimeLabel.text = formatRelaxTimer()
        }
    }

    // MARK: - Actions

    @objc private func startAndPauseButtonTapped() {
        cancelButton.isEnabled = true

        if isStarted {
            isStarted = false
            timer.invalidate()
            playAndPauseButton.configuration?.title = "Play"
            playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
        } else {
            isStarted = true
            timer.invalidate()
            playAndPauseButton.configuration?.title = "Pause"
            playAndPauseButton.configuration?.image = UIImage(systemName: "pause.fill")
            startTimer()
        }
    }

    @objc private func cancelButtonTapped() {
        cancelButton.isEnabled = false
        isStarted = false
        isWorkTime = true
        workingTime = 10
        relaxTime = 5
        timer.invalidate()
        countdownTimeLabel.text = "00:10"
        countdownTimeLabel.textColor = .white
        titleLabel.text = "Work"
        playAndPauseButton.configuration?.title = "Play"
        playAndPauseButton.configuration?.image = UIImage(systemName: "play.fill")
    }
}

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}


