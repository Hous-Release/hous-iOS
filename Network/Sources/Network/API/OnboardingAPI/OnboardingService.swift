//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation
import Alamofire

public enum OnboardingService {
    case postNewRoom(_ name: OnboardingDTO.Request.PostNewRoomRequestDTO)
  case postExistRoom(_ roomId: Int)
    case getIsExistRoom(_ code: OnboardingDTO.Request.GetIsExistRoomRequestDTO)
}

extension OnboardingService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {

    case .postNewRoom:
      return "/room"
    case let .postExistRoom(roomId):
      return "/room/\(roomId)/join"
    case .getIsExistRoom:
      return "/room/info"
    }
  }

  public var method: HTTPMethod {
    switch self {
    case .postNewRoom, .postExistRoom:
      return .post
    case .getIsExistRoom:
      return .get
    }
  }

  public var parameters: RequestParams {
    switch self {
    case let .postNewRoom(name):
      return .body(name)
    case .postExistRoom:
      return .requestPlain
    case let .getIsExistRoom(code):
      return .query(code)
    }
  }
}
