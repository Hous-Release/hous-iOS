//
//  File.swift
//  
//
//  Created by 김지현 on 2022/12/10.
//

import Foundation
import Alamofire

public enum UserService {
    case deleteUser(_ dto: UserDTO.Request.DeleteUserRequestDTO)
}

extension UserService: TargetType {
    public var baseURL: String {
        return API.apiBaseURL
    }

    public var path: String {
        switch self {
        case .deleteUser:
            return "/v1/user"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .deleteUser:
            return .delete
        }
    }

    public var parameters: RequestParams {
        switch self {
        case let .deleteUser(dto):
            return .body(dto)
        }
    }
}
