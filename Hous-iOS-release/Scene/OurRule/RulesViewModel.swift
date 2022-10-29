//
//  RulesViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/10/28.
//

import Foundation
import RxSwift
import RxCocoa
import Network


final class RulesViewModel {
  
  // Inputs
  let viewWillAppearSubject = PublishSubject<Void>()
  
  // Outputs
//  var keyRules: Driver<KeyRuleViewModel>
  var rules: Driver<[RuleViewModel]>
  
  init() {
    let rules = self.viewWillAppearSubject
      .asObservable()
      .flatMap { _ in
        NetworkService.shared.ruleRepository.getRulesName()
      }
      .asDriver(onErrorJustReturn: [])
    
    self.rules = rules.map(
      {
        $0.map { RuleViewModel(name: $0.name) }
      }
    )
    
//    self.keyRules = rules.map({ KeyRuleViewModel(rules: $0) })
  }
}

struct KeyRuleViewModel {
  let names: [String]
}

extension KeyRuleViewModel {
  init(rules: [RuleDTO.Response.Rule]) {
    let arr = rules.map { rule in
      rule.name
    }
    self.names = arr
  }
}

struct RuleViewModel {
  var name: String
}

extension RuleViewModel {
  init(rule: RuleDTO.Response.Rule) {
    self.name = rule.name
  }
}
