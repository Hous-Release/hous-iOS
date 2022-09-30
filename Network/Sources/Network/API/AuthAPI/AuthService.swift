//
//  AuthService.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import Foundation
import Alamofire

public enum AuthService {
  case login(_ dto: AuthDTO.Request.LoginRequestDTO)
  case refresh(_ dto: Token)
}

extension AuthService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .login:
      return "auth/login"
    case .refresh:
      return "auth/refresh"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .login:
      return .post
    case .refresh:
      return .post
    }
  }

  public var parameters: RequestParams {
    switch self {
    case let .login(dto):
      return .body(dto)
    case let .refresh(dto):
      return .body(dto)
    }
  }
}
