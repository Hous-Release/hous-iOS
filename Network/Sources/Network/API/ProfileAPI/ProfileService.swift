//
//  ProfileService.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//  Created by 김민재 on 2022/11/08.

import Foundation
import Alamofire

public enum ProfileService {
    case getAlarmInfo(_ data: ProfileDTO.Request.GetAlarmRequestDTO)
    case getProfile
    case getProfileTestResult(_ data: ProfileDTO.Request.ProfileTestResultDTO)
    case getHomieProfile(_ id: String)
    case getBadges
    case getProfileTest
    case getAlarmSettingInfo
    case updateRepresentBadge(_ id: Int)
    case putProfileEdit(_ data: ProfileDTO.Request.ProfileEditRequestDTO)
    case putProfileTest(_ data: ProfileDTO.Request.ProfileTestSaveRequestDTO)
    case patchAlarmSetting(_ data: ProfileDTO.Request.SaveAlarmSettingRequestDTO)
}

extension ProfileService: TargetType {
    public var baseURL: String {
        return API.apiBaseURL
    }
    
    public var path: String {
        switch self {
        case .getProfileTest:
            return "/user/personality/test"
        case .getProfile:
            return "/user"
        case .getHomieProfile(let id):
            return "/user/\(id)"
        case .getProfileTestResult:
            return "/user/personality"
        case .getBadges:
            return "/user/badges"
        case .getAlarmSettingInfo:
            return "/user/push"
        case .getAlarmInfo:
            return "/user/notifications"
            
        case .updateRepresentBadge(let id):
            return "/user/badge/\(id)/represent"
        case .putProfileTest:
            return "/user/personality"
        case .putProfileEdit:
            return "/user"
        case .patchAlarmSetting:
            return "/user/push"
        }
        
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getProfile, .getBadges, .getHomieProfile, .getProfileTestResult, .getProfileTest, .getAlarmSettingInfo, .getAlarmInfo:
            return .get
            
        case .putProfileEdit, .updateRepresentBadge, .putProfileTest:
            return .put
            
        case .patchAlarmSetting:
            return .patch
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .getProfile, .getBadges, .updateRepresentBadge, .getHomieProfile, .getProfileTest, .getAlarmSettingInfo:
            return .requestPlain
            
        case let .putProfileEdit(dto):
            return .body(dto)
            
        case let .putProfileTest(dto):
            return .body(dto)
            
        case let .patchAlarmSetting(dto):
            return .body(dto)
            
        case let .getProfileTestResult(dto):
            return .query(dto)
            
        case let .getAlarmInfo(dto):
            return .query(dto)
        }
    }
}


