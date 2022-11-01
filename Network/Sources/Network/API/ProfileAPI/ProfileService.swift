//
//  ProfileGetService.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//

import Foundation
import Alamofire

public enum ProfileService {
    case getProfile
}

extension ProfileService: TargetType {
    public var baseURL: String {
        return API.apiBaseURL
    }
    
    public var path: String {
        switch self {
        case .getProfile:
            return "/user"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getProfile:
            return .requestPlain
        }
    }
}


