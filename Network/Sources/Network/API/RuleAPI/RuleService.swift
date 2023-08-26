//
//  File.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import UIKit
import Alamofire

public enum RuleService {
  case createRule(_ dto: RuleDTO.Request.createRuleRequestDTO, images: [UIImage])
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
    case .deleteRule,
            .createRule,
            .updateRules:
        return "/v2/rule"
    case .getRuleData:
      return "/v1/rules"
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
    case .createRule(let dto, _):
      return .query(dto)
      
    case .updateRules(let dto):
      return .body(dto)
      
    case .deleteRule(let dto):
      return .body(dto)

    case .getRuleData:
      return .requestPlain

    }
  }

  public var multipart: MultipartFormData {
    switch self {
    case .createRule(_, let images):
      let multiPart = MultipartFormData()
      for (index, image) in images.enumerated() {
        if let pngData = image.pngData() {
          multiPart.append(pngData, withName: "image", fileName: "image-\(index).png", mimeType: "image/png")
        }
      }
      return multiPart
    default: return MultipartFormData()
    }
  }

}
