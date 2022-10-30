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
import RxDataSources

typealias SectionOfRules = SectionModel<TableViewSection, TableViewItem>

final class RulesViewModel {
  
  // Inputs
  let viewWillAppearSubject = PublishSubject<Void>()
  
  // Outputs
  var rules = PublishSubject<[SectionOfRules]>()
  
  let disposeBag = DisposeBag()
  
  init() {
    let rules = self.viewWillAppearSubject
      .debug("2 : ")
      .asObservable()
      .flatMap({ _ in
        NetworkService.shared.ruleRepository.getRulesName()
      })


//    var items: [TableViewItem] = []
//    rules.map { rules in
//
//      var arr: [String] = []
//
//      rules.enumerated().forEach { (idx, rule) in
//
//        if idx < 2 {
//          arr.append(rule.name)
//        } else if idx == 2 {
//          arr.append(rule.name)
//          let item = TableViewItem.keyRules(viewModel: KeyRuleViewModel(rules: arr))
//          items.append(item)
//        } else {
//          let item = TableViewItem.rule(viewModel: RuleViewModel(rule: rule))
//          items.append(item)
//        }
//      }
//    }
//
//    self.rules.onNext([SectionOfRules(model: .main, items: items)])
    
//    self.rules = rules.map(
//      {
//        $0.map { RuleViewModel(name: $0.name) }
//      }
//    )
//
//    self.keyRules = rules.map({ KeyRuleViewModel(rules: $0) })
  }
}

struct KeyRuleViewModel {
  let names: [String]
}

extension KeyRuleViewModel {
  init(rules: [String]) {
    self.names = rules
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

enum TableViewSection {
  case main
}

enum TableViewItem {
  case keyRules(viewModel: KeyRuleViewModel)
  case rule(viewModel: RuleViewModel)
}
