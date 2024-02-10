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

final class RulesViewModel: ViewModelType {

  // MARK: - Inputs
  struct Input {
    let viewWillAppear: Observable<Void>
    let backButtonDidTapped: Observable<Void>
    let moreButtonDidTapped: Observable<Void>
    let plusButtonDidTapped: Observable<Void>
    let ruleCellDidTapped: Observable<Int>
    let deleteRuleDidTapped: Observable<Int>
    let editMenuButtonDidTapped: Observable<Void>
    let guideMenuButtonDidTapped: Observable<Void>
  }

  // MARK: - Outputs
  struct Output {
    let rules: Driver<[HousRule]>
    let popViewController: Driver<Void>
    let housMenuAppear: Driver<Void>
    let presentAddViewController: Driver<Void>
    let ruleDetail: Driver<RuleDTO.Response.SingleRuleResponseDTO?>
    let deleteRuleComplete: Driver<Int?>
    let pushRepresentRulesViewController: Driver<Void>
    let presentGuideBottomSheet: Driver<Void>
  }

  private let housRulesSubject = PublishSubject<[HousRule]>()

  private let ruleDetailSubject = PublishSubject<RuleDTO.Response.SingleRuleResponseDTO?>()

  private let deleteRuleSubject = PublishSubject<Int?>()

  private let disposeBag = DisposeBag()

  private let repositoryProvider: ServiceProviderType

  func transform(input: Input) -> Output {

    input.viewWillAppear
      .subscribe { _ in
        self.repositoryProvider.ruleRepository.getRules()
      }
      .disposed(by: disposeBag)

    let housRules = housRulesSubject.asDriver(onErrorJustReturn: [])
    let popViewController = input.backButtonDidTapped.asDriver(onErrorJustReturn: ())
    let moreButtonDidTapped = input.moreButtonDidTapped.asDriver(onErrorJustReturn: ())
    let plusButtonDidTapped = input.plusButtonDidTapped
      .asDriver(onErrorJustReturn: ())
    let ruleDetail = ruleDetailSubject.asDriver(onErrorJustReturn: nil)
    let deleteRuleComplete = deleteRuleSubject.asDriver(onErrorJustReturn: nil)

    input.ruleCellDidTapped
      .subscribe { ruleId in
        self.repositoryProvider.ruleRepository.getRuleDetail(ruleId: ruleId)
      }
      .disposed(by: disposeBag)

    input.deleteRuleDidTapped
      .subscribe { ruleId in
        self.repositoryProvider.ruleRepository.deleteRule(ruleId: ruleId)
      }
      .disposed(by: disposeBag)

    return Output(rules: housRules,
                  popViewController: popViewController,
                  housMenuAppear: moreButtonDidTapped,
                  presentAddViewController: plusButtonDidTapped,
                  ruleDetail: ruleDetail,
                  deleteRuleComplete: deleteRuleComplete,
                  pushRepresentRulesViewController: input.editMenuButtonDidTapped.asDriver(onErrorJustReturn: ()),
                  presentGuideBottomSheet: input.guideMenuButtonDidTapped.asDriver(onErrorJustReturn: ()))
  }

  init(repositoryProvider: ServiceProviderType) {
    self.repositoryProvider = repositoryProvider
    bindRepository()
  }

}

extension RulesViewModel {
  func bindRepository() {
    repositoryProvider.ruleRepository.event
      .subscribe { event in
        switch event.element {
        case .deleteRule(let ruleId):
          self.deleteRuleSubject.onNext(ruleId)
        case .getRules(let rules):
          self.housRulesSubject.onNext(rules)
        case .sendError(let error):
          print(error?.message ?? "")
        case .none:
          return
        case .getRuleDetail(let dto):
          self.ruleDetailSubject.onNext(dto)
        }
      }.disposed(by: disposeBag)
  }
}
