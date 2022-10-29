//
//  File.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation

public extension RuleDTO.Request {
  struct updateRuleRequestDTO: Encodable {
    
    public let name: String
    
    public init(name: String) {
      self.name = name
    }
  }
  
  struct createRuleRequestDTO: Encodable {
    public let ruleNames: [String]
    
    public init(ruleNames: [String]) {
      self.ruleNames = ruleNames
    }
  }
  
  struct updateRulesOrderRequestDTO: Encodable {
    public let rulesIdList: [Int]
    
    public init(rulesIdList: [Int]) {
      self.rulesIdList = rulesIdList
    }
  }
  
  /// 삭제할 규칙들의 idList
  struct deleteRulesRequestDTO: Encodable {
    public let rulesIdList: [Int]
    
    public init(rulesIdList: [Int]) {
      self.rulesIdList = rulesIdList
    }
  }
  
}
