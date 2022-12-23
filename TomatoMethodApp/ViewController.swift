//
//  ViewController.swift
//  TomatoMethodApp
//
//  Created by Kristina Korotkova on 23/12/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

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
        return button
    }()



    // MARK: - Leficycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubviews([
            imageBackground,
            countdownTimeLabel,
            playAndPauseButton
        ])
    }

    // MARK: - Setup

    private func setupLayout() {
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

    }

    // MARK: - Actions


}

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
