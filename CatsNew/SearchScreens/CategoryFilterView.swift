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
    let scrollView: UIScrollView! = UIScrollView()
    let radioButtonsStackView: UIStackView! = UIStackView()
    let dataStorage = DataStorage()
    var radioButtons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        let catModels = dataStorage.getCats()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        self.addGestureRecognizer(tapGesture)

        initializeTitle()
        initializeRadioButtonsStackView()
        createRadioButtons(catModels)

        addSubviews()

        setupContainer()
        setupTitle()
        setupScrollView()
        setupRadioButtonsStackView()
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
        title.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        title.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
    }

    private func initializeTitle() {
        title.text = "Category"
        title.textAlignment = .left
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }

    private func setupRadioButtonsStackView() {
        radioButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        radioButtonsStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        radioButtonsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        radioButtonsStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        radioButtonsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func initializeRadioButtonsStackView() {
        radioButtonsStackView.axis = .vertical
        radioButtonsStackView.distribution = .equalCentering
        radioButtonsStackView.alignment = .leading
    }

    private func setupRadioButton(_ radioButton: UIButton) {
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.widthAnchor.constraint(equalTo: radioButtonsStackView.widthAnchor).isActive = true
        radioButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func initializeRadioButton(_ radioButton: UIButton, _ category: String) {
        radioButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        radioButton.setTitle("   \(category)", for: .normal)
        radioButton.setTitleColor(.black, for: .normal)
        radioButton.contentHorizontalAlignment = .left
        radioButton.setImage(UIImage(named: "circle.svg"), for: .normal)
        radioButton.setImage(UIImage(named: "record-circle.svg"), for: .selected)
        radioButton.addTarget(self, action: #selector(flipRadioButton(_:)), for: .touchUpInside)
    }

    @objc private func flipRadioButton(_ sender: UIButton) {
        if sender.isSelected {
            return
        }

        sender.isSelected.toggle()

        for radioButton in radioButtons {
            if radioButton != sender && radioButton.isSelected {
                radioButton.isSelected = false
            }
        }
    }

    private func createRadioButtons(_ catModels: [CatModel]) {
        let categories = Array(Set(catModels.map { $0.category }))
        for category in categories {
            let radioButton = UIButton()

            initializeRadioButton(radioButton, category)
            radioButtonsStackView.addArrangedSubview(radioButton)
            setupRadioButton(radioButton)
            radioButtons.append(radioButton)
        }
    }

    private func addSubviews() {
        self.addSubview(container)
        container.addSubview(title)
        container.addSubview(scrollView)
        scrollView.addSubview(radioButtonsStackView)
    }
}
