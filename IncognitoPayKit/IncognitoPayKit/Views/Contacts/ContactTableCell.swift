//
//  ContactTableCell.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 20.12.20.
//  Copyright © 2020 NO DANCE MONKEY. All rights reserved.
//

import UIKit

class ContactTableCell: UITableViewCell {
  private var contact: Contact? = nil
  
  convenience init(_ contact: Contact) {
    self.init()
    self.contact = contact
  }
  
  fileprivate lazy var contentImage: UIImageView = {
    let bundle = Bundle(for: ContactTableCell.self)
    
    let image = UIImage(
      named: contact?.image ?? "",
      in: bundle,
      compatibleWith: nil
    )
    
    let imageView = UIImageView(frame: CGRect(x: 8, y: 4, width: 50, height: 50))
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 25
    imageView.layer.masksToBounds = true
    imageView.image = image
    return (imageView)
  }()
  
  fileprivate lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "\(contact?.firstName ?? "") \(contact?.lastName ?? "")"
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return (label)
  }()
  
  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    
    backgroundColor = .secondarySystemBackground
    
    contentView.addSubview(contentImage)
    contentView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 58),
      titleLabel.leadingAnchor.constraint(equalTo: contentImage.safeAreaLayoutGuide.trailingAnchor, constant: 20),
      titleLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
    ])
  }
}
