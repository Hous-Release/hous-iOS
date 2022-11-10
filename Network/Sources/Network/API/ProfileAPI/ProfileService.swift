//
//  ProfileGetService.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//  Created by 김민재 on 2022/11/08.

import Foundation
import Alamofire

public enum ProfileService {
    case getProfile
    case getBadges
    case updateRepresentBadge(_ id: Int)
}

extension ProfileService: TargetType {
    public var baseURL: String {
        return API.apiBaseURL
    }
    
    public var path: String {
        switch self {
        case .getProfile:
            return "/user"
        case .getBadges:
            return "/user/badges"
        case .updateRepresentBadge(let id):
            return "/user/badge/\(id)/represent"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getProfile, .getBadges:
            return .get
        case .updateRepresentBadge:
            return .put
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getProfile, .getBadges, .updateRepresentBadge:
            return .requestPlain
        }
    }
}


