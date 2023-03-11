//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/25.
//

import Foundation
import Alamofire

public enum RoomService {
  case postNewRoom(_ name: OnboardingDTO.Request.PostNewRoomRequestDTO)
  case postExistRoom(_ roomId: Int)
  case getIsExistRoom(_ code: OnboardingDTO.Request.GetIsExistRoomRequestDTO)
  case updateRoomName(_ dto: RoomDTO.Request.updateRoomNameRequestDTO)
  case leaveRoom
}

extension RoomService: TargetType {
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
    case .updateRoomName:
      return "/room/name"
    case .leaveRoom:
      return "/room/leave"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .postNewRoom, .postExistRoom:
      return .post
    case .getIsExistRoom:
      return .get
    case .updateRoomName:
      return .put
    case .leaveRoom:
      return .delete
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
    case let .updateRoomName(dto):
      return .body(dto)
    case .leaveRoom:
      return .requestPlain
    }
  }
}


