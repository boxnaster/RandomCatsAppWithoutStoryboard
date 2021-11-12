//
//  CategoryFilter.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 22.10.2021.
//

import Foundation
import UIKit

class CategoryFilter: UIViewController {

    private let container: UIView! = UIView()
    private let filterTitle: UILabel! = UILabel()
    private var tableView: UITableView! = UITableView()
    private let applyButton: UIButton! = UIButton()
    private let clearAllButton: UIButton! = UIButton()

    private var searchSpinner: UIActivityIndicatorView! = UIActivityIndicatorView(style: .large)
    private let apiKey = "66597ab0-3a1d-444d-ad96-8e393fb9cf9e"
    private let endpoint = "https://api.thecatapi.com/v1/categories"
    private var isSearching = false
    private var areCategoriesLoaded = false
    private var categories: [Category] = []
    private var searchSession: URLSession?
    private var searchTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        initializeTitle()
        initializeApplyButton()
        initializeTableView()
        initializeClearAllButton()

        addSubviews()

        setupContainer()
        setupTitle()
        setupClearAllButton()
        setupApplyButton()
        setupTableView()

        searchSession = URLSession(configuration: .default)
        getCategories()
    }

    private func getCategories() {
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
                    let result = CategoriesParser.parseCategories(responseData: responseData, response: response, error: error)
                    switch result {
                    case .success(let parsedCategories):
                        if parsedCategories.isEmpty {
                            strongSelf.areCategoriesLoaded = true
                        } else {
                            strongSelf.categories.append(contentsOf: parsedCategories)
                            strongSelf.tableView.reloadData()
                        }
                    case .failure(let error):
                        strongSelf.presentError(error)
                    }
                    strongSelf.isSearching = false
                    strongSelf.changeSpinnerState()
                })
            })
        searchTask = localTask
        localTask?.resume()
    }

    private func prepareAndGetUrlComponents() -> URLComponents {
        guard var urlComponents = URLComponents(string: endpoint) else {
            return URLComponents()
        }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api-key", value: apiKey))
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
        searchSpinner.center = tableView.center
    }

    @objc private func tapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if container.frame.contains(location) {
            return
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    private func setupContainer() {
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75).isActive = true
    }

    private func setupTitle() {
        filterTitle.translatesAutoresizingMaskIntoConstraints = false
        filterTitle.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 20).isActive = true
        filterTitle.topAnchor.constraint(equalTo: container.topAnchor, constant: 20).isActive = true
    }

    private func initializeTitle() {
        filterTitle.text = "Category"
        filterTitle.textAlignment = .left
    }

    private func initializeClearAllButton() {
        clearAllButton.setTitle("clear all", for: .normal)
        clearAllButton.setTitleColor(.blue, for: .normal)
        clearAllButton.addTarget(self, action: #selector(flipClearAllButton), for: .touchUpInside)
    }

    private func setupClearAllButton() {
        clearAllButton.translatesAutoresizingMaskIntoConstraints = false
        clearAllButton.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        clearAllButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
    }

    @objc private func flipClearAllButton() {
        DataStorage.selectedCategory = nil
        tableView.reloadData()
    }

    private func initializeTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RadioButtonTableViewCell.self, forCellReuseIdentifier: RadioButtonTableViewCell.cellIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.allowsMultipleSelection = false
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: container.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: filterTitle.bottomAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor).isActive = true
    }

    private func initializeApplyButton() {
        applyButton.backgroundColor = .blue
        applyButton.setTitle("Apply filter", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        applyButton.contentHorizontalAlignment = .center
        applyButton.addTarget(self, action: #selector(flipApplyButton), for: .touchUpInside)
    }

    @objc func flipApplyButton() {
        NotificationCenter.default.post(name: NSNotification.Name("RefreshCats"), object: nil)
        dismiss(animated: true, completion: nil)
    }

    private func setupApplyButton() {
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        applyButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        applyButton.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        applyButton.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.07).isActive = true
    }

    private func addSubviews() {
        view.addSubview(container)
        container.addSubview(filterTitle)
        container.addSubview(clearAllButton)
        container.addSubview(tableView)
        container.addSubview(applyButton)
        container.addSubview(searchSpinner)
    }
}

extension CategoryFilter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonTableViewCell.cellIdentifier, for: indexPath)
                as? RadioButtonTableViewCell else {
                    fatalError("Can't dequeue reusable cell.")
                }

        let category = categories[indexPath.row]
        let isSelected = DataStorage.selectedCategory?.identifier == category.identifier

        if indexPath.row < categories.count {
            cell.categoryName.text = category.name
            cell.radioButton.isSelected = isSelected
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50.0
    }
}

extension CategoryFilter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTableViewCell else {
            fatalError("There is no cell at indexPath \(indexPath).")
        }

        let category = categories[indexPath.row]
        cell.radioButton.isSelected = true
        DataStorage.selectedCategory = category
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTableViewCell else {
            fatalError("There is no cell at indexPath \(indexPath).")
        }

        cell.radioButton.isSelected = false
        DataStorage.selectedCategory = nil
    }
}
