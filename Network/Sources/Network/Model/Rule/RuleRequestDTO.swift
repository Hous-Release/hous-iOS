//
//  File.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation

public extension RuleDTO.Request {
    struct createRuleRequestDTO: Encodable {
        public let ruleNames: [String]
        
        public init(ruleNames: [String]) {
            self.ruleNames = ruleNames
        }
    }
    
    struct updateRulesRequestDTO: Encodable {
        public let rules: [Rule]
        
        public init(rules: [Rule]) {
            self.rules = rules
        }
    }
    
    struct Rule: Encodable {
        public let id: Int
        public let name: String
        
        public init(id: Int, name: String) {
            self.id = id
            self.name = name
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
