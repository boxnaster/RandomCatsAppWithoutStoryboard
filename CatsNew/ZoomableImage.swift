//
//  ZoomableImage.swift
//  RandomCatsAppWithoutStoryboard
//
//  Created by Анастасия Тимофеева on 28.10.2021.
//

import Foundation
import UIKit

class ZoomableImage: UIViewController, UIScrollViewDelegate {

    private var imageView: UIImageView! = UIImageView()
    private var scrollView: UIScrollView! = UIScrollView()
    private var image: UIImage!
    private var closeButton: UIButton! = UIButton()

    init(image: UIImage!) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        initializeCloseButton()
        initializeScrollView()

        addSubviews()

        setupCloseButton()
        setupScrollView()
        setupImageView()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    @objc private func flipCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func setupImageView() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
    }

    private func initializeScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }

    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        closeButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -30).isActive = true
    }

    private func initializeCloseButton() {
        closeButton.setImage(UIImage(named: "x.svg"), for: .normal)
        closeButton.addTarget(self, action: #selector(flipCloseButton), for: .touchUpInside)
        closeButton.isHidden = false
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(closeButton)
    }
}
