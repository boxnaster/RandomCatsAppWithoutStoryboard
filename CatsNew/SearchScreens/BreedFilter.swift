//
//  BreedCheckBox.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 22.10.2021.
//

import Foundation
import UIKit

class BreedFilter: UIViewController {

    private let container: UIView! = UIView()
    private let filterTitle: UILabel! = UILabel()
    private let scrollView: UIScrollView! = UIScrollView()
    private let checkBoxesStackView: UIStackView! = UIStackView()
    private let dataStorage = DataStorage()

    override func viewDidLoad() {
        super.viewDidLoad()

        let catModels = dataStorage.getCats()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        view.addGestureRecognizer(tapGesture)

        initializeTitle()
        initializeCheckBoxesStackView()
        createCheckBoxes(catModels)

        addSubviews()

        setupContainer()
        setupTitle()
        setupScrollView()
        setupCheckBoxesStackView()
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
        filterTitle.text = "Breed"
        filterTitle.textAlignment = .left
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: filterTitle.bottomAnchor, constant: 20).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }

    private func setupCheckBoxesStackView() {
        checkBoxesStackView.translatesAutoresizingMaskIntoConstraints = false
        checkBoxesStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        checkBoxesStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        checkBoxesStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        checkBoxesStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func initializeCheckBoxesStackView() {
        checkBoxesStackView.axis = .vertical
        checkBoxesStackView.distribution = .equalCentering
        checkBoxesStackView.alignment = .leading
    }

    private func setupCheckBox(_ checkBox: UIButton) {
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.widthAnchor.constraint(equalTo: checkBoxesStackView.widthAnchor).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func initializeCheckBox(_ checkBox: UIButton, _ breed: String) {
        checkBox.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        checkBox.setTitle("   \(breed)", for: .normal)
        checkBox.setTitleColor(.black, for: .normal)
        checkBox.contentHorizontalAlignment = .left
        checkBox.setImage(UIImage(named: "square.svg"), for: .normal)
        checkBox.setImage(UIImage(named: "check-square.svg"), for: .selected)
        checkBox.addTarget(self, action: #selector(flipCheckBox(_:)), for: .touchUpInside)
    }

    @objc private func flipCheckBox(_ sender: UIButton) {
        sender.isSelected.toggle()
    }

    private func createCheckBoxes(_ catModels: [CatModel]) {
        let breeds = Array(Set(catModels.flatMap { Array($0.breeds) }))
        for breed in breeds {
            let checkBox = UIButton()

            initializeCheckBox(checkBox, breed)
            checkBoxesStackView.addArrangedSubview(checkBox)
            setupCheckBox(checkBox)
        }
    }

    private func addSubviews() {
        view.addSubview(container)
        container.addSubview(filterTitle)
        container.addSubview(scrollView)
        scrollView.addSubview(checkBoxesStackView)
    }
}
