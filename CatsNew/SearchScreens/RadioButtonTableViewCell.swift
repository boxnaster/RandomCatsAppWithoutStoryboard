//
//  RadioButtonTableViewCell.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 11.11.2021.
//

import Foundation
import UIKit

class RadioButtonTableViewCell: UITableViewCell {

    static let cellIdentifier = "CategoriesTableViewCellID"
    var radioButton = RadioButton()
    var categoryName: UILabel! = UILabel()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        initializeCategoryName()
        setupRadioButton()
        setupCategoryName()
    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        categoryName = nil
//        radioButton.isSelected = false
//    }

    private func setupRadioButton() {
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func setupCategoryName() {
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        categoryName.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 20).isActive = true
        categoryName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func initializeCategoryName() {
        categoryName.numberOfLines = 1
        categoryName.lineBreakMode = .byTruncatingTail
    }

    private func addSubviews() {
        addSubview(radioButton)
        addSubview(categoryName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
