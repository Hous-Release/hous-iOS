//
//  File.swift
//  
//
//  Created by 김민재 on 2022/09/25.
//

import Foundation
import Alamofire

public enum RoomService {
  case updateRoomName(_ dto: RoomDTO.Request.updateRoomNameRequestDTO)
  case leaveRoom
}

extension RoomService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }
  
  public var path: String {
    switch self {
    case .updateRoomName:
      return "/room/name"
    case .leaveRoom:
      return "/room/leave"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .updateRoomName:
      return .put
    case .leaveRoom:
      return .delete
    }
  }
  
  public var parameters: RequestParams {
    switch self {
    case let .updateRoomName(dto):
      return .body(dto)
    case let .leaveRoom:
      return .requestPlain
    }
  }
}


