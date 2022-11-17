//
//  ProfileService.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//  Created by 김민재 on 2022/11/08.

import Foundation
import Alamofire

public enum ProfileService {
    case getProfile
    case getHomieProfile(_ id:String)
    case getBadges
    case updateRepresentBadge(_ id: Int)
    case putProfileEdit(_ data: ProfileDTO.Request.ProfileEditRequestDTO)
}

extension ProfileService: TargetType {
    public var baseURL: String {
        return API.apiBaseURL
    }
    
    public var path: String {
        switch self {
        case .getProfile:
            return "/user"
        case .getHomieProfile(let id):
            return "/user/\(id)"
        case .getBadges:
            return "/user/badges"
        case .updateRepresentBadge(let id):
            return "/user/badge/\(id)/represent"
            
        case .putProfileEdit:
            return "/user"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getProfile, .getBadges, .getHomieProfile:
            return .get
            
        case .putProfileEdit:
            return .put
        case .updateRepresentBadge:
            return .put
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getProfile, .getBadges, .updateRepresentBadge, .getHomieProfile:
            return .requestPlain
            
        case let .putProfileEdit(dto):
            return .body(dto)
        }
    }
}


