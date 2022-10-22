//
//  UIStackView+Extension.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/07.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ views: UIView...) {
    for view in views {
      self.addArrangedSubview(view)
    }
  }
  
  func removeFully(view: UIView) {
    removeArrangedSubview(view)
    view.removeFromSuperview()
  }
  
  func removeFullyAllArrangedSubviews() {
    arrangedSubviews.forEach { (view) in
      removeFully(view: view)
    }
  }
}
