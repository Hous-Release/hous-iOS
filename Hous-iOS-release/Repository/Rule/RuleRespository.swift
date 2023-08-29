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
  case getRuleDetail(RuleDTO.Response.SingleRuleResponseDTO)
  case getRules([HousRule])
  case deleteRule(Int?)
  case sendError(HouseErrorModel?)
}

public protocol RuleRepository {
  var event: PublishSubject<RuleRepositoryEvent> { get }

  func getRules()
  func getRuleDetail(ruleId: Int)
  func deleteRule(ruleId: Int)
}

public final class RuleRepositoryImp: BaseService, RuleRepository {

  public var event = PublishSubject<RuleRepositoryEvent>()

  private let disposeBag = DisposeBag()

  public func deleteRule(ruleId: Int) {
    NetworkService.shared.ruleRepository.deleteRule(ruleId: ruleId)
      .subscribe(onNext: { [weak self] ruleId in
        guard let self else { return }
        self.event.onNext(.deleteRule(ruleId))
      })
      .disposed(by: disposeBag)
  }

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

  public func getRuleDetail(ruleId: Int) {
    NetworkService.shared.ruleRepository.getRuleDetail(ruleId: ruleId)
      .subscribe { ruleDetailDTO in
        guard let dto = ruleDetailDTO.element,
              let model = dto
        else { return }

        self.event.onNext(.getRuleDetail(model))
      }
      .disposed(by: disposeBag)
  }

}
