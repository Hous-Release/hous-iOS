//
//  Optional+Exntension.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/12/24.
//

import Foundation

extension Optional where Wrapped == Date {
  func dateToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")

    guard let date = self else {
      return ""
    }

    return dateFormatter.string(from: date)
  }

}
