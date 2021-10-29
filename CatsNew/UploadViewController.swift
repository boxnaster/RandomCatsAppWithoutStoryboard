//
//  UploadViewController.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 13.10.2021.
//

import Foundation
import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let dataStorage = DataStorage()
    var catModels: [CatModel]
    var collectionView: UICollectionView!
    let plusButton: UIButton! = UIButton()

    init() {
        catModels = dataStorage.getCats()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My Uploaded Images"
        view.backgroundColor = .white

        initializeCollectionView()
        initializePlusButton()

        addSubviews()

        setupPlusButton()
        setupCollectionView()
    }

    @objc private func flipPlusButton() {
        showAlert()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    private func setupPlusButton() {
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    }

    private func initializePlusButton() {
        plusButton.setImage(UIImage(named: "plus-circle-fill.svg"), for: .normal)
        plusButton.addTarget(self, action: #selector(flipPlusButton), for: .touchUpInside)
    }

    @objc private func flipDeleteButton() {

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

    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(plusButton)
    }

    private func showAlert() {
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                return
            }
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }

        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        [libraryAction, cameraAction, cancel].forEach({ alertController.addAction($0) })
        present(alertController, animated: true, completion: nil)
    }
}

extension UploadViewController: UICollectionViewDataSource {
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

        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "dash-circle.svg"), for: .normal)
        deleteButton.addTarget(self, action: #selector(flipDeleteButton), for: .touchUpInside)

        cell.addSubview(deleteButton)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 20).isActive = true
        deleteButton.topAnchor.constraint(equalTo: cell.topAnchor, constant: 20).isActive = true

        return cell
    }
}

extension UploadViewController: UICollectionViewDelegateFlowLayout {
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

extension UploadViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController(catModel: catModels[indexPath.item])
        navigationController?.pushViewController(singleImageViewController, animated: true)
    }
}
