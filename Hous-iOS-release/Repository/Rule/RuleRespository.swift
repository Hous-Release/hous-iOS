//
//  RuleRespository.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/13.
//

import Foundation

import Network

import RxSwift
import RxCocoa

public enum RuleRepositoryEvent {
  case getRules([HousRule])
  case sendError(HouseErrorModel?)
}

public protocol RuleRepository {
  var event: PublishSubject<RuleRepositoryEvent> { get }

  func getRules()
}

public final class RuleRepositoryImp: BaseService, RuleRepository {
  public var event = PublishSubject<RuleRepositoryEvent>()

  private let disposeBag = DisposeBag()

  public func getRules() {
    NetworkService.shared.ruleRepository.getRulesName()
      .subscribe { rules in
        guard let rules = rules.element else { return }
        let housRules = rules.map {
          return HousRule(id: $0.id, name: $0.name)
        }
        self.event.onNext(.getRules(housRules))
      }
      .disposed(by: disposeBag)
  }

}
