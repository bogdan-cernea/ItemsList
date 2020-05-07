//
//  ItemTableViewCell.swift
//  ItemsList
//
//  Created by bogdan.cernea on 07/05/2020.
//  Copyright © 2020 bogdan.cernea. All rights reserved.
//

import UIKit
import SDWebImage

class ItemTableViewCell: UITableViewCell {
  
  var aspectRatioConstraint: NSLayoutConstraint?
  var imageDownloadCompletion: ((ItemTableViewCell) -> Void)?
  var item: Item? {
    didSet {
      // Set item properties
      self.titleLabel.text = self.item?.title
      self.descriptionLabel.text = self.item?.description
      let imageUrl = URL(string: self.item?.imageHref ?? "")
      let placeholderImage = UIImage(named: "Placeholder")
      self.updateAspectRatioForImage(placeholderImage ?? .init()) // Reset aspect ratio to placeholder image
      self.itemImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "Placeholder"), options: []) { [weak self] (image, err, type, url) in
        guard let self = self, let image = image else {
          return
        }
        self.updateAspectRatioForImage(image)
        self.imageDownloadCompletion?(self)
      }
    }
  }
  
  private let defaultMargin: CGFloat = 10.0
  
  // Title label
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .darkGray
    label.font = .boldSystemFont(ofSize: 18)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // Description label
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 14.0)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // Item image view
  private let itemImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage()
    imageView.backgroundColor = .clear
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  // Item stack view
  private let itemStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    stackView.spacing = CGFloat(10.0)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    itemStackView.addArrangedSubview(titleLabel)
    itemStackView.addArrangedSubview(descriptionLabel)
    itemStackView.addArrangedSubview(itemImageView)
    contentView.addSubview(itemStackView)
    contentView.autoresizingMask = .flexibleHeight
    
    self.preservesSuperviewLayoutMargins = false
    self.separatorInset = UIEdgeInsets.zero
    self.layoutMargins = UIEdgeInsets.zero
    
    selectionStyle = .none
    cellConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Update image aspect ratio
  private func updateAspectRatioForImage(_ image: UIImage) {
    self.aspectRatioConstraint?.isActive = false
    self.aspectRatioConstraint = self.itemImageView.widthAnchor.constraint(equalTo: self.itemImageView.heightAnchor, multiplier: image.size.width / image.size.height)
    self.aspectRatioConstraint?.isActive = true
  }
  
  // Cell constraints
  private func cellConstraints() {
    NSLayoutConstraint.activate([
      itemStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: defaultMargin),
      itemStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: defaultMargin),
      itemStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -defaultMargin),
      itemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -defaultMargin)
    ])
  }
}
