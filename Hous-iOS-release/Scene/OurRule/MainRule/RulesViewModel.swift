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
  }

  // MARK: - Outputs
  struct Output {
    var rules: Driver<[HousRule]>
    var popViewController: Driver<Void>
    var presentBottomSheet: Driver<Void>
    var presentAddViewController: Driver<Void>
    var ruleDetail: Driver<RuleDTO.Response.SingleRuleResponseDTO?>
  }

  private let housRulesSubject = PublishSubject<[HousRule]>()

  private let ruleDetailSubject = PublishSubject<RuleDTO.Response.SingleRuleResponseDTO?>()

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
    let presentBottomSheet = input.moreButtonDidTapped.asDriver(onErrorJustReturn: ())
    let plusButtonDidTapped = input.plusButtonDidTapped
      .asDriver(onErrorJustReturn: ())
    let ruleDetail = ruleDetailSubject.asDriver(onErrorJustReturn: nil)

    input.ruleCellDidTapped
      .subscribe { ruleId in
        self.repositoryProvider.ruleRepository.getRuleDetail(ruleId: ruleId)
      }
      .disposed(by: disposeBag)

    return Output(rules: housRules,
                  popViewController: popViewController,
                  presentBottomSheet: presentBottomSheet,
                  presentAddViewController: plusButtonDidTapped,
                  ruleDetail: ruleDetail)
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
