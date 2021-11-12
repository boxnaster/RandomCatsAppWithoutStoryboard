//
//  CheckBoxButton.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 10.11.2021.
//

import Foundation
import UIKit

class CheckBoxButton: UIButton {

    let checkedImage = UIImage(named: "check-square")
    let uncheckedImage = UIImage(named: "square")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(uncheckedImage, for: .normal)
        setImage(checkedImage, for: .selected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
