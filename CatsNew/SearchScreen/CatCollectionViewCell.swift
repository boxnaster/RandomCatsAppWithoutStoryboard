//
//  CatCollectionViewCell.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 12.11.2021.
//

import Foundation
import UIKit

class CatCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "CatCollectionViewCellID"

    public var imageView: UIImageView! = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        setupImageView()
    }
    
    private func setupImageView() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
