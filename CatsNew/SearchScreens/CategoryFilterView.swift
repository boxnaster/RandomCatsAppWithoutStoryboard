//
//  CategoryFilterView.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 23.10.2021.
//

import Foundation
import UIKit

class CategoryFilterView: UIView {

    let container: UIView! = UIView()
    let title: UILabel! = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        self.addGestureRecognizer(tapGesture)

        initializeTitle()

        self.addSubview(container)
        container.addSubview(title)

        setupContainer()
        setupTitle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if container.frame.contains(location) {
            return
        } else {
            self.removeFromSuperview()
        }
    }

    private func setupContainer() {
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.75).isActive = true
    }

    private func setupTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        title.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
    }

    private func initializeTitle() {
        title.text = "category"
        title.textAlignment = .left
    }
}
