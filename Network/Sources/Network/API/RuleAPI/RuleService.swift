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
    case updateRule(_ dto: RuleDTO.Request.createRuleRequestDTO, ruleId: Int, images: [UIImage])
  case deleteRule(ruleId: Int)
  case getRuleData
    case getRuleDetail(ruleId: Int)
}

extension RuleService: TargetType {
  public var baseURL: String {
    return API.apiBaseURL
  }

  public var path: String {
    switch self {
    case .createRule:
        return "/v2/rule"
    case let .updateRule(_, ruleId, _):
        return "/v2/rule/\(ruleId)"
    case .getRuleData:
      return "/v1/rules"
    case .getRuleDetail(let ruleId):
        return "/v2/rule/\(ruleId)"
    case .deleteRule(let ruleId):
        return "/v2/rule/\(ruleId)"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .createRule:
      return .post
    case .updateRule:
      return .put
    case .deleteRule:
      return .delete
    case .getRuleData, .getRuleDetail:
      return .get
    }
  }
  
  public var parameters: RequestParams {
    switch self {
    case .getRuleData, .getRuleDetail, .createRule, .deleteRule, .updateRule:
      return .requestPlain
    }
  }

  public var multipart: MultipartFormData {
    switch self {
    case .createRule(let dto, let images), .updateRule(let dto, _, let images):
      let multiPart = MultipartFormData()

      for (index, image) in images.enumerated() {
          if  let jpegData = image.jpegData(compressionQuality: 0.2) {
            multiPart.append(jpegData, withName: "images", fileName: "image-\(index).jpeg", mimeType: "image/jpeg")
        }
      }
        multiPart.append(Data(dto.name.utf8), withName: "name")
        multiPart.append(Data(dto.description.utf8), withName: "description")
      return multiPart
    default: return MultipartFormData()
    }
  }

}
