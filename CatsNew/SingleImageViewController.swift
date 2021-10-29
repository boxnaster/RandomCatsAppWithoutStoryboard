//
//  SingleImageViewController.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 12.10.2021.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {

    private var catModel: CatModel
    private var scrollView: UIScrollView! = UIScrollView()
    private var contentView: UIView! = UIView()
    private var imageView: UIImageView! = UIImageView()
    private var likeButton = LikeButton()
    private var breedsLabel: UILabel! = UILabel()
    private var categoryLabel: UILabel! = UILabel()

    init(catModel: CatModel) {
        self.catModel = catModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.title = catModel.name
        self.view.backgroundColor = .white

        initializeImageView()
        initializeBreedsLabel()
        initializeCategoryLabel()

        addSubviews()

        setupScrollView()
        setupContentView()
        setupImageView()
        setupLikeButton()
        setupBreedsLabel()
        setupCategoryLabel()
    }

    @objc func imageTapped() {
        let zoomableImage = ZoomableImage(image: imageView.image)
        zoomableImage.modalPresentationStyle = .overFullScreen
        present(zoomableImage, animated: true, completion: nil)
    }

    private func initializeImageView() {
        imageView.image = catModel.image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func initializeBreedsLabel() {
        breedsLabel.numberOfLines = 0
        breedsLabel.text = "Breeds:\n-\(catModel.breeds.joined(separator: "\n-"))"
        breedsLabel.textAlignment = .left
        breedsLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        breedsLabel.textColor = .black
    }

    private func initializeCategoryLabel() {
        categoryLabel.numberOfLines = 0
        categoryLabel.text = "Category: \(catModel.category)"
        categoryLabel.textAlignment = .left
        categoryLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        categoryLabel.textColor = .black
    }

    private func addSubviews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(breedsLabel)
        contentView.addSubview(categoryLabel)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true

        guard let catImage = imageView.image else {
            return
        }

        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor,
                                         multiplier: (catImage.size.width) / (catImage.size.height),
                                         constant: 0.0).isActive = true
    }

    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    }

    private func setupBreedsLabel() {
        breedsLabel.translatesAutoresizingMaskIntoConstraints = false
        breedsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        breedsLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 20).isActive = true
        breedsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive = true
    }

    private func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: breedsLabel.bottomAnchor, constant: 20).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
