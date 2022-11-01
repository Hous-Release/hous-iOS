//
//  File.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation
import Alamofire

public enum RuleService {
  case createRule(_ dto: RuleDTO.Request.createRuleRequestDTO)
  case updateRules(_ dto: RuleDTO.Request.updateRulesRequestDTO)
  case deleteRule(_ dto: RuleDTO.Request.deleteRulesRequestDTO)
  case getRuleData
}

extension RuleService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }
  
  public var path: String {
    switch self {
    case .createRule,
        .updateRules,
        .deleteRule,
        .getRuleData:
      return "/rules"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .createRule:
      return .post
    case .updateRules:
      return .put
    case .deleteRule:
      return .delete
    case .getRuleData:
      return .get
    }
  }
  
  public var parameters: RequestParams {
    switch self {
    case .createRule:
      return .requestPlain
      
    case .updateRules(let dto):
      return .body(dto)
      
    case .deleteRule:
      return .requestPlain

    case .getRuleData:
      return .requestPlain

    }
  }
}
