//
//  BreedCheckBox.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 22.10.2021.
//

import Foundation
import UIKit

class BreedFilterView: UIView {

    let container: UIView! = UIView()
    let title: UILabel! = UILabel()
    let scrollView: UIScrollView! = UIScrollView()
    let checkBoxesStackView: UIStackView! = UIStackView()
    let dataStorage = DataStorage()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let catModels = dataStorage.getCats()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        self.addGestureRecognizer(tapGesture)

        initializeTitle()
        initializeCheckBoxesStackView()
        createCheckBoxes(catModels)

        addSubviews()

        setupContainer()
        setupTitle()
        setupScrollView()
        setupCheckBoxesStackView()
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
        title.text = "Breed"
        title.textAlignment = .left
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
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
        self.addSubview(container)
        container.addSubview(title)
        container.addSubview(scrollView)
        scrollView.addSubview(checkBoxesStackView)
    }
}
