//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation

public struct Token: Codable {
  public let accessToken: String
  public let refreshToken: String
}
