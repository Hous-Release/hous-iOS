//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/11.
//

import Foundation

extension Sequence where Element: Hashable {
  func uniqued() -> [Element] {
    var set = Set<Element>()
    return filter { set.insert($0).inserted }
  }
}
