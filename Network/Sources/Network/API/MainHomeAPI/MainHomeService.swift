//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/23.
//

import Foundation
import Alamofire

public enum MainHomeService {
  case getHomeData
}

extension MainHomeService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }
  
  public var path: String {
    switch self {
    case .getHomeData:
      return "/v1/home"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getHomeData:
      return .get
    }
  }
  
  public var parameters: RequestParams {
    switch self {
    case .getHomeData:
      return .requestPlain
    }
  }
}

