//
//  CategoryFilterView.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 23.10.2021.
//

import Foundation
import UIKit

class CategoryFilter: UIViewController {

    private let container: UIView! = UIView()
    private let filterTitle: UILabel! = UILabel()
    private let scrollView: UIScrollView! = UIScrollView()
    private let radioButtonsStackView: UIStackView! = UIStackView()
    private let applyButton: UIButton! = UIButton()
    private let dataStorage = DataStorage()
    private var radioButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let catModels = dataStorage.getCats()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        view.addGestureRecognizer(tapGesture)

        initializeTitle()
        initializeRadioButtonsStackView()
        initializeApplyButton()
        createRadioButtons(catModels)

        addSubviews()

        setupContainer()
        setupTitle()
        setupApplyButton()
        setupScrollView()
        setupRadioButtonsStackView()
    }

    @objc private func tapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if container.frame.contains(location) {
            return
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    private func setupContainer() {
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75).isActive = true
    }

    private func setupTitle() {
        filterTitle.translatesAutoresizingMaskIntoConstraints = false
        filterTitle.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        filterTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
    }

    private func initializeTitle() {
        filterTitle.text = "Category"
        filterTitle.textAlignment = .left
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: filterTitle.bottomAnchor, constant: 20).isActive = true
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

    private func initializeApplyButton() {
        applyButton.backgroundColor = .blue
        applyButton.setTitle("Apply filter", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        applyButton.contentHorizontalAlignment = .center
    }

    private func setupApplyButton() {
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        applyButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        applyButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        applyButton.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.07).isActive = true
    }

    private func addSubviews() {
        view.addSubview(container)
        container.addSubview(filterTitle)
        container.addSubview(scrollView)
        scrollView.addSubview(radioButtonsStackView)
        container.addSubview(applyButton)
    }
}
