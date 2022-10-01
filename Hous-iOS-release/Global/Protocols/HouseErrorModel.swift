//
//  HouseErrorModel.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/30.
//

import Foundation

public struct HouseErrorModel {
  public init(success: Bool?, status: Int?, message: String?) {
    self.success = success
    self.status = status
    self.message = message
  }

  let success: Bool?
  let status: Int?
  let message: String?
}
