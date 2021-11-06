//
//  FavouritesViewController.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 13.10.2021.
//

import Foundation
import UIKit

class FavouritesViewController: UIViewController {

    private let dataStorage = DataStorage()
    private var catModels: [CatModel]
    private var collectionView: UICollectionView!

    init() {
        catModels = dataStorage.getCats()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Favourites"
        view.backgroundColor = .white

        initializeCollectionView()
        view.addSubview(collectionView)
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func initializeCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.white
    }
}

extension FavouritesViewController: UICollectionViewDataSource {
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

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
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

extension FavouritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let singleImageViewController = SingleImageViewController(catModel: catModels[indexPath.item])
     //   navigationController?.pushViewController(singleImageViewController, animated: true)
    }
}
