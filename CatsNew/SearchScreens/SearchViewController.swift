//
//  SearchViewController.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 13.10.2021.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    private var collectionView: UICollectionView!
    private let breedFilterButton: UIButton! = UIButton()
    private let categoryFilterButton: UIButton! = UIButton()
    private var searchSpinner: UIActivityIndicatorView! = UIActivityIndicatorView(style: .large)
    private let apiKey = "66597ab0-3a1d-444d-ad96-8e393fb9cf9e"
    private let endpoint = "https://api.thecatapi.com/v1/images/search"
    private let pageLimit = 10
    private var page = 0
    private var isSearching = false
    private var cats: [Cat] = []
    private var searchSession: URLSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Random Cats"
        view.backgroundColor = .white

        searchSession = URLSession(configuration: .default)
        getCats()

        initializeSearchSpinner()
        initializeBreedFilterButton()
        initializeCategoryFilterButton()
        initializeCollectionView()

        addSubviews()

        setupBreedFilterButton()
        setupCategoryFilterButton()
        setupCollectionView()

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCats), name: NSNotification.Name("RefreshCats"), object: nil)
    }

    @objc private func refreshCats() {
        setBreedFilterButtonTitle()
        setCategoryFilterButtonTitle()
        cats = []
        page = 0
        getCats()
    }

    private func getCats() {
        let urlComponents = prepareAndGetUrlComponents()
        guard let url = urlComponents.url else { return }
        isSearching = true
        changeSpinnerState()
        let localTask = searchSession?.dataTask(
            with: url,
            completionHandler: { [weak self] (responseData: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let result = CatsParser.parseCats(responseData: responseData, response: response, error: error)
                    switch result {
                    case .success(let parsedCats):
                        for cat in parsedCats {
                            let url = URL(string: cat.url)
                            let data = try? Data(contentsOf: url!)
                            let image = UIImage(data: data!)
                            cat.image = image!
                        }
                        var originalCats: [Cat] = []
                        let existingCatIds = strongSelf.cats.map { $0.identifier }
                        for cat in parsedCats {
                            if !existingCatIds.contains(cat.identifier) {
                                originalCats.append(cat)
                            }
                        }
                        strongSelf.cats.append(contentsOf: originalCats)
                        strongSelf.collectionView.reloadData()
                    case .failure(let error):
                        strongSelf.presentError(error)
                    }
                    strongSelf.isSearching = false
                    strongSelf.changeSpinnerState()
                })
            })
        localTask?.resume()
    }

    private func prepareAndGetUrlComponents() -> URLComponents {
        guard var urlComponents = URLComponents(string: endpoint) else {
            return URLComponents()
        }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "limit", value: String(pageLimit)))
        queryItems.append(URLQueryItem(name: "page", value: String(page)))
        queryItems.append(URLQueryItem(name: "api-key", value: apiKey))

        if DataStorage.selectedCategory != nil {
            queryItems.append(URLQueryItem(name: "category_ids", value: String(DataStorage.selectedCategory!.identifier)))
        }
        let breeds = DataStorage.selectedBreeds.map { $0.identifier }
        queryItems.append(URLQueryItem(name: "breed_ids", value: breeds.joined(separator: ",")))
        urlComponents.queryItems = queryItems

        return urlComponents
    }

    private func presentError(_ error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func changeSpinnerState() {
        if isSearching {
            searchSpinner.startAnimating()
        } else {
            searchSpinner.stopAnimating()
        }
    }

    private func initializeSearchSpinner() {
        searchSpinner.hidesWhenStopped = true
        searchSpinner.stopAnimating()
        searchSpinner.center = view.center
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: categoryFilterButton.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func setupCategoryFilterButton() {
        categoryFilterButton.translatesAutoresizingMaskIntoConstraints = false
        categoryFilterButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        categoryFilterButton.topAnchor.constraint(equalTo: breedFilterButton.bottomAnchor).isActive = true
        categoryFilterButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        categoryFilterButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }

    private func setupBreedFilterButton() {
        breedFilterButton.translatesAutoresizingMaskIntoConstraints = false
        breedFilterButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        breedFilterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        breedFilterButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        breedFilterButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }

    private func initializeBreedFilterButton() {
        setBreedFilterButtonTitle()
        breedFilterButton.setTitleColor(.black, for: .normal)
        breedFilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        breedFilterButton.contentHorizontalAlignment = .left
        breedFilterButton.titleLabel?.numberOfLines = 1
        breedFilterButton.titleLabel?.lineBreakMode = .byTruncatingTail
        breedFilterButton.backgroundColor = UIColor(red: 255 / 255, green: 235 / 255, blue: 220 / 255, alpha: 1)
        breedFilterButton.layer.borderWidth = 0.5
        breedFilterButton.layer.borderColor = UIColor.gray.cgColor
        breedFilterButton.addTarget(self, action: #selector(flipBreedFilterButton), for: .touchUpInside)
    }

    private func initializeCategoryFilterButton() {
        setCategoryFilterButtonTitle()
        categoryFilterButton.setTitleColor(.black, for: .normal)
        categoryFilterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        categoryFilterButton.contentHorizontalAlignment = .left
        categoryFilterButton.titleLabel?.numberOfLines = 1
        categoryFilterButton.titleLabel?.lineBreakMode = .byTruncatingTail
        categoryFilterButton.backgroundColor = UIColor(red: 255 / 255, green: 235 / 255, blue: 220 / 255, alpha: 1)
        categoryFilterButton.layer.borderWidth = 0.5
        categoryFilterButton.layer.borderColor = UIColor.gray.cgColor
        categoryFilterButton.addTarget(self, action: #selector(flipCategoryFilterButton), for: .touchUpInside)
    }

    private func setBreedFilterButtonTitle() {
        if !DataStorage.selectedBreeds.isEmpty {
            breedFilterButton.setTitle("Breed: \(DataStorage.selectedBreeds.map { $0.name }.joined(separator: ", "))", for: .normal)
        } else {
            breedFilterButton.setTitle("Breed: all", for: .normal)
        }
    }

    private func setCategoryFilterButtonTitle() {
        if DataStorage.selectedCategory != nil {
            categoryFilterButton.setTitle("Category: \(DataStorage.selectedCategory?.name ?? "")", for: .normal)
        } else {
            categoryFilterButton.setTitle("Category: all", for: .normal)
        }
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
        let breedFilter = BreedFilter()
        breedFilter.modalPresentationStyle = .overFullScreen
        present(breedFilter, animated: true, completion: nil)
    }

    @objc func flipCategoryFilterButton() {
        let categoryFilter = CategoryFilter()
        categoryFilter.modalPresentationStyle = .overFullScreen
        present(categoryFilter, animated: true, completion: nil)
    }

    private func addSubviews() {
        view.addSubview(breedFilterButton)
        view.addSubview(categoryFilterButton)
        view.addSubview(collectionView)
        collectionView.addSubview(searchSpinner)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item < cats.count {
            let cat = cats[indexPath.item]
            let ratio = CGFloat(cat.width) / collectionView.frame.size.width
            return CGSize(width: collectionView.frame.size.width, height: (CGFloat(cat.height) / ratio))

        }
        return CGSize()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController(catId: cats[indexPath.item].identifier)
        navigationController?.pushViewController(singleImageViewController, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // переделать на количество элементов page * pageLimit + 5
        if collectionView.contentOffset.y >= collectionView.contentSize.height - collectionView.bounds.size.height {
            if !isSearching {
                page += 1
                getCats()
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.item < cats.count {
            let cat = cats[indexPath.item]
            let imageView = UIImageView(image: cat.image)
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            cell.backgroundView = imageView
            // переделать backgroundView
            // добавить кеш
        }
        return cell
    }
}
