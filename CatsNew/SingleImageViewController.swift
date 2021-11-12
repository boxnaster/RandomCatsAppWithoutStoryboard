//
//  SingleImageViewController.swift
//  CatsNew
//
//  Created by Анастасия Тимофеева on 12.10.2021.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {

 //   private let catModel: CatModel
 //   private let dataStorage = DataStorage()
    private let catId: String
    private var scrollView: UIScrollView! = UIScrollView()
 //   private var contentView: UIView! = UIView()
    private var imageView: UIImageView! = UIImageView()
    private var likeButton = LikeButton()
    private var breedsLabel: UILabel! = UILabel()
    private var categoryLabel: UILabel! = UILabel()

    private var searchSpinner: UIActivityIndicatorView! = UIActivityIndicatorView(style: .large)
    private let apiKey = "66597ab0-3a1d-444d-ad96-8e393fb9cf9e"
    private let subId = UIDevice.current.identifierForVendor?.uuidString
    private let endpoint = "https://api.thecatapi.com/v1/images/"
    private var isSearching = false
    private var cat: Cat
    private var searchSession: URLSession?
    private var searchTask: URLSessionDataTask?

    init(catId: String) {
        self.catId = catId
        cat = Cat(identifier: "", url: "", width: 0, height: 0, image: UIImage(), breeds: [], categories: [])
     //   catModel = dataStorage.getCats()[0]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.title = cat.identifier
        self.view.backgroundColor = .white

        searchSession = URLSession(configuration: .default)
        getCat()

        initializeImageView()
     //   initializeBreedsLabel()
     //   initializeCategoryLabel()
        initializeSearchSpinner()

        addSubviews()

        setupScrollView()
      //  setupContentView()
        setupLikeButton()
        setupBreedsLabel()
        setupCategoryLabel()

      //  searchSession = URLSession(configuration: .default)
     //   getCat()
    }

    private func getCat() {
        let urlComponents = prepareAndGetUrlComponents()
        guard let url = urlComponents.url else {
            return
        }
        isSearching = true
        changeSpinnerState()
        let localTask = searchSession?.dataTask(
            with: url,
            completionHandler: { [weak self] (responseData: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let result = CatsParser.parseCat(responseData: responseData, response: response, error: error)
                    switch result {
                    case .success(let parsedCat):
                        strongSelf.cat = parsedCat
                        let url = URL(string: strongSelf.cat.url)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)
                        strongSelf.imageView.image = image
                        strongSelf.setupImageView()
                        strongSelf.initializeBreedsLabel()
                        strongSelf.initializeCategoryLabel()
                    case .failure(let error):
                        strongSelf.presentError(error)
                    }
                    strongSelf.isSearching = false
                    strongSelf.changeSpinnerState()
                })
            })
      //  searchTask = localTask
        localTask?.resume()

    }

    private func prepareAndGetUrlComponents() -> URLComponents {
        guard var urlComponents = URLComponents(string: endpoint + catId) else {
            return URLComponents()
        }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "sub_id", value: subId))
        queryItems.append(URLQueryItem(name: "api-key", value: apiKey))
        queryItems.append(URLQueryItem(name: "include_vote", value: ""))
        queryItems.append(URLQueryItem(name: "include_favourite", value: ""))
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

    @objc func imageTapped() {
        let zoomableImage = ZoomableImage(image: imageView.image)
        zoomableImage.modalPresentationStyle = .overFullScreen
        present(zoomableImage, animated: true, completion: nil)
    }

    private func initializeImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func initializeBreedsLabel() {
        breedsLabel.numberOfLines = 0
        if !cat.breeds.isEmpty {
            breedsLabel.text = "Breeds:\n-\(cat.breeds.map { $0.name }.joined(separator: "\n-"))"
        } else {
            breedsLabel.text = "Breeds: unknown"
        }
        breedsLabel.textAlignment = .left
        breedsLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        breedsLabel.textColor = .black
    }

    private func initializeCategoryLabel() {
        categoryLabel.numberOfLines = 0
        if !cat.categories.isEmpty {
            categoryLabel.text = "Category: \(cat.categories.map { $0.name }.joined(separator: "\n-"))"
        } else {
            categoryLabel.text = "Category: unknown"
        }
        categoryLabel.textAlignment = .left
        categoryLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        categoryLabel.textColor = .black
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(likeButton)
        scrollView.addSubview(breedsLabel)
        scrollView.addSubview(categoryLabel)
        scrollView.addSubview(searchSpinner)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(imageView)
//        contentView.addSubview(likeButton)
//        contentView.addSubview(breedsLabel)
//        contentView.addSubview(categoryLabel)
//        contentView.addSubview(searchSpinner)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

//    private func setupContentView() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//    }

    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        imageView.contentMode = .scaleAspectFit
       // let size = UIScreen.main.bounds
       // imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)


      //  imageView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 100.0)
      //  imageView.contentMode = .top
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
 //       imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
       // imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).priority = .defaultHigh
       // imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
       // imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
       // imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.contentMode = .top
       // imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
       // imageView.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: 20).isActive = true
    }

    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
 //       likeButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        likeButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        likeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    }

    private func setupBreedsLabel() {
        breedsLabel.translatesAutoresizingMaskIntoConstraints = false
  //      breedsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        breedsLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        breedsLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 20).isActive = true
   //     breedsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive = true
        breedsLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 20).isActive = true
    }

    private func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
   //     categoryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: breedsLabel.bottomAnchor, constant: 20).isActive = true
    //    categoryLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20).isActive = true
        categoryLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 20).isActive = true
    //    categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}
