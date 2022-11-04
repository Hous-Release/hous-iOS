//
//  File.swift
//  
//
//  Created by 김지현 on 2022/11/04.
//

import Foundation
import Alamofire

public enum OnboardingService {
  case postNewRoom(_ dto: OnboardingDTO.Request.CreateNewRoomRequestDTO)
  case postExistRoom(_ dto: OnboardingDTO.Request.EnterExistRoomRequestDTO)
  case getIsExistRoom(_ dto: OnboardingDTO.Request.CheckExistRoomRequestDTO)
}

extension OnboardingService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {

    case .postNewRoom:
      return "/room"
    case let .postExistRoom(dto):
      return "/room/\(dto.roomId)/join"
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
    case let .postNewRoom(dto):
      return .body(dto)
    case .postExistRoom:
      return .requestPlain
    case let .getIsExistRoom(dto):
      return .query(dto)
    }
  }
}
