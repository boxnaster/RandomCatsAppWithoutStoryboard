//
//  RadioButton.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 11.11.2021.
//

import Foundation
import UIKit

class RadioButton: UIButton {

    let selectedImage = UIImage(named: "record-circle")
    let unselectedImage = UIImage(named: "circle")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(unselectedImage, for: .normal)
        setImage(selectedImage, for: .selected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
