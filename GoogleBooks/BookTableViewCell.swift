//
//  BookTableViewCell.swift
//  GoogleBooks
//
//  Created by Gary on 3/6/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import UIKit


final class BookTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BookInfoCell"

    var titleText: String? {
       didSet {
            self.titleLabel.text = titleText
        }
       }

    var authorText: String? {
           didSet {
                self.authorLabel.text = authorText
           }
       }

    var descriptionText: String? {
           didSet {
                self.descriptionLabel.text = descriptionText
           }
       }

    private var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .white
        label.font = UIFont(name:"HelveticaNeue-bold", size: 14.0)
        return label
    }()

    private var authorLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        //label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .white
        label.font = UIFont(name:"HelveticaNeue", size: 14.0)
        return label
    }()

    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.textColor = .white
        label.font = UIFont(name:"HelveticaNeue", size: 14.0)
        return label
    }()

    var cellImageView: AsyncCachedImageView = {
        var imageView = AsyncCachedImageView(frame: CGRect.zero, urlString: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init( style: style, reuseIdentifier: reuseIdentifier)

        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(self.cellImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.authorLabel)
        self.addSubview(self.descriptionLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
        cellImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
        cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
        cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
        cellImageView.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.4),

        titleLabel.leftAnchor.constraint(equalTo: self.cellImageView.rightAnchor, constant: 6),
        titleLabel.topAnchor.constraint(equalTo: self.cellImageView.topAnchor, constant: 0),
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 4),

        authorLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
        authorLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4),
        authorLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 0),

        descriptionLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
        descriptionLabel.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 4),
        descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
        descriptionLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 0),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


