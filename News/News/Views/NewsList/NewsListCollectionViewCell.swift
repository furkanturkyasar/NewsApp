//
//  NewsListCollectionViewCell.swift
//  News
//
//  Created by Furkan Türkyaşar on 1.02.2025.
//

import Kingfisher
import UIKit

final class NewsListCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewsListCell"

    // MARK: - UI Elements

    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .categoryTitle
        label.text = "Economy"
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let circleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let dotsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "ellipsis")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Init

    override init (frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Article) {
        titleLabel.text = model.title
        subTitleLabel.text = "By \(model.source.name)"

        if let date = model.publishedAt.toDate() {
            timeLabel.text = date.timeAgo()
        } else {
            timeLabel.text = NSLocalizedString("unknown_time", comment: "")
        }

        if let imageUrl = model.urlToImage, let url = URL(string: imageUrl) {
            articleImageView.kf.setImage(with: url)
        } else {
            articleImageView.image = UIImage(systemName: "photo.circle")
        }
    }
}

private extension NewsListCollectionViewCell {
    func setupUI() {
        configureImageView()
        configureLabels()
        configureStackView()
        configureDotsIcon()
    }

    func configureImageView() {
        contentView.addSubview(articleImageView)

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            articleImageView.widthAnchor.constraint(equalToConstant: 137)
        ])
    }

    func configureLabels() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subTitleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 12),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configureStackView() {
        contentView.addSubview(bottomStackView)

        bottomStackView.addArrangedSubview(categoryLabel)
        bottomStackView.addArrangedSubview(circleIcon)
        bottomStackView.addArrangedSubview(timeLabel)

        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bottomStackView.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 12),
            bottomStackView.heightAnchor.constraint(equalToConstant: 24),

            circleIcon.widthAnchor.constraint(equalToConstant: 6),
            circleIcon.heightAnchor.constraint(equalToConstant: 6)
        ])
    }

    func configureDotsIcon() {
        contentView.addSubview(dotsIcon)

        NSLayoutConstraint.activate([
            dotsIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dotsIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
