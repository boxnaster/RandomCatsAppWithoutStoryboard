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
    var buttons = [UIButton]()
    var collectionView: UICollectionView!

    init() {
        catModels = dataStorage.getCats()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        initializeCollectionView()
        initializeButtons()
    }

    override func loadView() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)

        view = collectionView
    }

    @objc private func flipCatButton(sender: UIButton) {
        guard let catModel = catModels.first(where: { $0.catId == sender.tag }) else { return }
        let singleImageViewController = SingleImageViewController(catModel: catModel)
        navigationController?.pushViewController(singleImageViewController, animated: true)
    }

    private func initializeButtons() {
        for catModel in catModels {
            let button = UIButton()
            button.setImage(catModel.image, for: .normal)
            button.tag = catModel.catId
            button.addTarget(self, action: #selector(flipCatButton), for: .touchUpInside)
            buttons.append(button)
        }
    }

    private func initializeCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        catModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let data = self.buttons[indexPath.item]
        cell.backgroundView = data
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 300)
    }
}
