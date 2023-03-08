//
//  UITableView+Extension.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/17.
//

import UIKit

extension UITableView {
  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: T.className,
                                                for: indexPath) as? T else {
          fatalError("Could not find cell with reuseID \(T.className)")
      }
      return cell
  }

  func register<T: UITableViewCell>(cell: T.Type,
                                    forCellReuseIdentifier reuseIdentifier: String = T.className
  ) {
    self.register(cell, forCellReuseIdentifier: reuseIdentifier)
  }
}
