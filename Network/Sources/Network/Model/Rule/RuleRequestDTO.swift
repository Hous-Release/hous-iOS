//
//  File.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation

public extension RuleDTO.Request {
    struct createRuleRequestDTO: Encodable {
        public let name: String
        public let description: String
        
        public init(name: String, description: String) {
            self.name = name
            self.description = description
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
    
    struct RepresentRulesRequestDTO: Encodable {
        public let rules: [Int]
        
        public init(rules: [Int]) {
            self.rules = rules
        }
    }
    
}
