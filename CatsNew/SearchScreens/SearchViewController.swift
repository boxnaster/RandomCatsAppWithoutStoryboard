//
//  SearchViewController.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 13.10.2021.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    let dataStorage = DataStorage()
    let catModels: [CatModel]
    let breeds: [String]
    let categories: [String]
    var collectionView: UICollectionView!
    let breedFilterButton: UIButton! = UIButton()
    let categoryFilterButton: UIButton! = UIButton()

    init() {
        catModels = dataStorage.getCats()
        breeds = Array(Set(catModels.flatMap { Array($0.breeds) }))
        categories = Array(Set(catModels.map { $0.category }))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        initializeBreedFilterButton()
        initializeCategoryFilterButton()
        initializeCollectionView()

        addSubviews()

        setupBreedFilterButton()
        setupCategoryFilterButton()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: categoryFilterButton.bottomAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func setupCategoryFilterButton() {
        categoryFilterButton.translatesAutoresizingMaskIntoConstraints = false
        categoryFilterButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        categoryFilterButton.topAnchor.constraint(equalTo: breedFilterButton.bottomAnchor).isActive = true
        categoryFilterButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func setupBreedFilterButton() {
        breedFilterButton.translatesAutoresizingMaskIntoConstraints = false
        breedFilterButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        breedFilterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        breedFilterButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func initializeBreedFilterButton() {
        breedFilterButton.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        breedFilterButton.setTitle("breed: \(breeds.joined(separator: ", "))", for: .normal)
        breedFilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        breedFilterButton.contentHorizontalAlignment = .left
        breedFilterButton.titleLabel?.numberOfLines = 1
        breedFilterButton.titleLabel?.lineBreakMode = .byTruncatingTail
        breedFilterButton.backgroundColor = .orange
        breedFilterButton.layer.borderWidth = 0.5
        breedFilterButton.layer.borderColor = UIColor.gray.cgColor
        breedFilterButton.addTarget(self, action: #selector(flipBreedFilterButton), for: .touchUpInside)
    }

    private func initializeCategoryFilterButton() {
        categoryFilterButton.setTitle("category: \(categories.joined(separator: ", "))", for: .normal)
        categoryFilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        categoryFilterButton.contentHorizontalAlignment = .left
        categoryFilterButton.titleLabel?.numberOfLines = 1
        categoryFilterButton.titleLabel?.lineBreakMode = .byTruncatingTail
        categoryFilterButton.backgroundColor = .orange
        categoryFilterButton.layer.borderWidth = 0.5
        categoryFilterButton.layer.borderColor = UIColor.gray.cgColor
        categoryFilterButton.addTarget(self, action: #selector(flipCategoryFilterButton), for: .touchUpInside)
    }

    private func initializeCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
    }

    @objc func flipBreedFilterButton() {
        let breedFilterView = BreedFilterView()
        self.view.addSubview(breedFilterView)
    }

    @objc func flipCategoryFilterButton() {
        let categoryFilterView = CategoryFilterView()
        self.view.addSubview(categoryFilterView)
    }

    private func addSubviews() {
        view.addSubview(breedFilterButton)
        view.addSubview(categoryFilterButton)
        view.addSubview(collectionView)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let data = catModels[indexPath.item]
        let backgroundImage = UIImageView(image: data.image)
        backgroundImage.layer.cornerRadius = 10
        backgroundImage.clipsToBounds = true
        cell.backgroundView = backgroundImage
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let catImage = catModels[indexPath.item].image else {
            return CGSize()
        }
        let ratio = (catImage.size.width) / collectionView.frame.size.width
        return CGSize(width: collectionView.frame.size.width, height: ((catImage.size.height) / ratio))
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController(catModel: catModels[indexPath.item])
        navigationController?.pushViewController(singleImageViewController, animated: true)
    }
}
