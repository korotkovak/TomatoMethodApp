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





    // MARK: - Leficycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
    }

    private func setupHierarchy() {
        view.addSubviews([
            imageBackground
        ])
    }

    // MARK: - Setup

    // MARK: - Actions


}

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
