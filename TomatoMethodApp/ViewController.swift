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



    // MARK: - Leficycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubviews([
            imageBackground,
            countdownTimeLabel
        ])
    }

    // MARK: - Setup

    private func setupLayout() {
        countdownTimeLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }

    }

    // MARK: - Actions


}

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
