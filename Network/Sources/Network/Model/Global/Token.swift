//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

public struct Token: Codable {
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }

  public let accessToken: String
  public let refreshToken: String
}
