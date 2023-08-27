//
//  File.swift
//  
//
//  Created by 김민재 on 2022/10/28.
//

public extension RuleDTO.Response {
  struct RuleResponseDTO: Decodable {
    public let rules: [Rule]
  }

  struct SingleRuleResponseDTO: Decodable {
    public let id: Int
    public let name: String
    public let description: String
    public let images: [String]
    public let updatedAt: String
  }
  
  struct Rule: Decodable {
    public let id: Int
    public let name: String
  }
  
  struct updateRulesResponseDTO: Decodable {
    
  }
}

