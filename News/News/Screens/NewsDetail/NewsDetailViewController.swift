//
//  NewsDetailViewController.swift
//  News
//
//  Created by Furkan Türkyaşar on 6.02.2025.
//

import Kingfisher
import UIKit

protocol NewsDetailOutputProtocol: AnyObject {}

final class NewsDetailViewController: UIViewController {
    private var viewModel: NewsDetailViewModel!

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.outputDelegate = self
    }

    init(article: Article) {
        self.viewModel = .init(article: article)
        super.init(nibName: nil, bundle: nil)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsDetailViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
        configureScrollView()
        configureContainerView()
        configureTitleLabel()
        configureImageView()
        configureTextView()
    }

    func configureScrollView() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureContainerView() {
        scrollView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func configureTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text = viewModel.article.title

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    func configureImageView() {
        containerView.addSubview(imageView)

        if let imageUrl = viewModel.article.urlToImage, let url = URL(string: imageUrl) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo.circle")
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 211)
        ])
    }

    func configureTextView() {
        containerView.addSubview(contentTextView)
        let content = String(repeating: viewModel.article.content ?? "", count: 4)
        contentTextView.text = content

        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contentTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    @objc func shareTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: NSLocalizedString("share_news", comment: ""), style: .default) { _ in
            self.shareArticle(from: self)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)

        actionSheet.addAction(shareAction)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true)
    }

    func shareArticle(from viewController: UIViewController) {
        let url = viewModel.article.url
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        viewController.present(activityViewController, animated: true)
    }
}

// MARK: - NewsDetailOutputProtocol

extension NewsDetailViewController: NewsDetailOutputProtocol {}
