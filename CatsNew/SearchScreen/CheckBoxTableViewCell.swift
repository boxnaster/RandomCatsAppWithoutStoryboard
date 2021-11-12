//
//  CheckBoxTableViewCell.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 09.11.2021.
//

import Foundation
import UIKit

class CheckBoxTableViewCell: UITableViewCell {

    static let cellIdentifier = "BreedsTableViewCellID"
    var checkBoxButton = CheckBoxButton()
    var breedName: UILabel! = UILabel()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        initializeBreedName()
        setupCheckBoxButton()
        setupBreedName()
    }

    private func setupCheckBoxButton() {
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        checkBoxButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        checkBoxButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func setupBreedName() {
        breedName.translatesAutoresizingMaskIntoConstraints = false
        breedName.leftAnchor.constraint(equalTo: checkBoxButton.rightAnchor, constant: 20).isActive = true
        breedName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func initializeBreedName() {
        breedName.numberOfLines = 1
        breedName.lineBreakMode = .byTruncatingTail
    }

    private func addSubviews() {
        addSubview(checkBoxButton)
        addSubview(breedName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
