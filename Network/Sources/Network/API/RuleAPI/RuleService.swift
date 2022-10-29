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
  case updateRuleName(_ dto: RuleDTO.Request.updateRuleRequestDTO)
  case updateRuleOrder(_ dto: RuleDTO.Request.updateRulesOrderRequestDTO)
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
        .updateRuleOrder,
        .deleteRule,
        .getRuleData:
      return "/rules"
    case .updateRuleName(let ruleId):
      return "rule/\(ruleId)"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .createRule:
      return .post
    case .updateRuleName, .updateRuleOrder:
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
    case .updateRuleName:
      return .requestPlain

    case .updateRuleOrder:
      return .requestPlain

    case .deleteRule:
      return .requestPlain

    case .getRuleData:
      return .requestPlain

    }
  }
}
