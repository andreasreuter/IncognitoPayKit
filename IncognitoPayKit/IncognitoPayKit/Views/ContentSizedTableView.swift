//
//  ContentSizedTableView.swift
//  IncognitoPayKit
//
//  Created by Andreas Reuter on 22.12.20.
//

import UIKit

class ContentSizedTableView: UITableView {
  override var contentSize: CGSize {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    return (CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height))
  }
}
