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

  // MARK: - Inputs
  let viewWillAppearSubject = PublishRelay<Void>()
  let backButtonDidTapped = PublishRelay<Void>()
  let moreButtonDidTapped = PublishRelay<Void>()

  // MARK: - Outputs
  var rules: Observable<[SectionOfRules]>
  var popViewController: Observable<Void>
  var presentBottomSheet: Observable<Void>
  var ruleWithIds: Observable<[RuleWithIdViewModel]>

  private let disposeBag = DisposeBag()

  init() {
    let viewWillAppear = self.viewWillAppearSubject
      .asObservable()
      .flatMap { _ in
        NetworkService.shared.ruleRepository.getRulesName()
      }
      .share()

    let defaultViewItem = viewWillAppear.map { res -> [TableViewItem] in

        if res.isEmpty {
          return [TableViewItem.keyRules(viewModel: KeyRuleViewModel(rules: [], rulesTotalCount: 0))]
        }
      let rulesTotalCount = res.count
        var items: [TableViewItem] = []
        var arr: [String] = []
        var isOnlyKeyRule = false

        res.enumerated().forEach { (idx, rule) in

          if res.count < 3 {
            arr.append(rule.name)
            isOnlyKeyRule = true
          } else {
            if idx < 2 {
              arr.append(rule.name)
            } else if idx == 2 {
              arr.append(rule.name)
              let item = TableViewItem.keyRules(
                viewModel: KeyRuleViewModel(rules: arr, rulesTotalCount: rulesTotalCount)
              )
              items.append(item)

            } else {
              let item = TableViewItem.rule(viewModel: RuleViewModel(rule: rule))
              items.append(item)
            }
          }
        }

        if isOnlyKeyRule {
          let item = TableViewItem.keyRules(
            viewModel: KeyRuleViewModel(rules: arr, rulesTotalCount: rulesTotalCount)
          )
          items.append(item)
        }

        return items
      }
      .map { [SectionOfRules(model: .main, items: $0)] }

    let ruleWithIdItems = viewWillAppear.map { res -> [RuleWithIdViewModel] in

      let items = res.map { rule in
        RuleWithIdViewModel(id: rule.id, name: rule.name)
      }

      return items
    }

    rules = Observable.merge(defaultViewItem)
    ruleWithIds = Observable.merge(ruleWithIdItems)

    popViewController = backButtonDidTapped.asObservable()
    presentBottomSheet = moreButtonDidTapped.asObservable()
  }
}

// MARK: - OnlyNameRuleViewModel
struct RuleViewModel {
  var name: String
}

extension RuleViewModel {
  init(rule: RuleDTO.Response.Rule) {
    self.name = rule.name
  }
}

// MARK: - RuleWithIdViewModel
struct RuleWithIdViewModel {
  let id: Int
  var name: String
  mutating func updateRuleName(name: String) {
    self.name = name
  }
}

extension RuleWithIdViewModel {
  init(rule: RuleDTO.Response.Rule) {
    self.id = rule.id
    self.name = rule.name
  }
}

// MARK: - TableView Section Model

// MARK: - KeyRuleViewModel
struct KeyRuleViewModel {
  let rulesTotalCount: Int
  let names: [String]
}

extension KeyRuleViewModel {
  init(rules: [String], rulesTotalCount: Int) {
    self.names = rules
    self.rulesTotalCount = rulesTotalCount
  }
}

typealias SectionOfRules = SectionModel<TableViewSection, TableViewItem>

enum TableViewSection {
  case main
}

enum TableViewItem {
  case keyRules(viewModel: KeyRuleViewModel)
  case rule(viewModel: RuleViewModel)
  case editRule(viewModel: RuleWithIdViewModel)
}
