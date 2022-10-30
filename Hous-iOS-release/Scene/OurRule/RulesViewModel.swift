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


final class RulesViewModel {
  
  // Inputs
  let viewWillAppearSubject = PublishRelay<Void>()
  let backButtonDidTapped = PublishRelay<Void>()
  let moreButtonDidTapped = PublishRelay<Void>()
  
  // Outputs
  var rules: Observable<[SectionOfRules]>
  var popViewController: Observable<Void>
  var presentBottomSheet: Observable<Void>
  
  private let disposeBag = DisposeBag()
  
  init() {
    let viewWillAppear = self.viewWillAppearSubject
      .debug("2 : ")
      .asObservable()
      .flatMap { _ in
        NetworkService.shared.ruleRepository.getRulesName()
      }.map { res -> [TableViewItem] in
        
        if res.isEmpty {
          print(res)
          return [TableViewItem.keyRules(viewModel: KeyRuleViewModel(rules: []))]
        }
        
        var items: [TableViewItem] = []
        var arr: [String] = []
        var isOnlyKeyRule = false
        
        res.enumerated().forEach { (idx, rule) in
          print("\(idx)번 인덱스의 규칙 : \(rule) 🏄")
          if res.count < 3 {
            arr.append(rule.name)
            isOnlyKeyRule = true
          } else {
            if idx < 2 {
              arr.append(rule.name)
            } else if idx == 2 {
              arr.append(rule.name)
              let item = TableViewItem.keyRules(viewModel: KeyRuleViewModel(rules: arr))
              items.append(item)
              print("여기까지가 keyRules : \(items)")
            } else {
              let item = TableViewItem.rule(viewModel: RuleViewModel(rule: rule))
              items.append(item)
            }
          }
        }
        if isOnlyKeyRule {
          let item = TableViewItem.keyRules(viewModel: KeyRuleViewModel(rules: arr))
          items.append(item)
        }
        print("items ==== ", items)
        return items
      }
      .map { [SectionOfRules(model: .main, items: $0)] }
    
    
    rules = Observable.merge(viewWillAppear)
    
    
    popViewController = backButtonDidTapped.asObservable()
    presentBottomSheet = moreButtonDidTapped.asObservable()
    
//    self.rules = rules.map(
//      {
//        $0.map { RuleViewModel(name: $0.name) }
//      }
//    )
//
//    self.keyRules = rules.map({ KeyRuleViewModel(rules: $0) })
  }
}

//MARK: - KeyRuleViewModel
struct KeyRuleViewModel {
  let names: [String]
}

extension KeyRuleViewModel {
  init(rules: [String]) {
    self.names = rules
  }
}

//MARK: - NormalRuleViewModel
struct RuleViewModel {
  var name: String
}

extension RuleViewModel {
  init(rule: RuleDTO.Response.Rule) {
    self.name = rule.name
  }
}

//MARK: - TableView Section Model
typealias SectionOfRules = SectionModel<TableViewSection, TableViewItem>

enum TableViewSection {
  case main
}

enum TableViewItem {
  case keyRules(viewModel: KeyRuleViewModel)
  case rule(viewModel: RuleViewModel)
}
