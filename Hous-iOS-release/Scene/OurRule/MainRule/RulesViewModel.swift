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
  }

  // MARK: - Outputs
  struct Output {
    var rules: Driver<[HousRule]>
    var popViewController: Driver<Void>
    var presentBottomSheet: Driver<Void>
  }

  private let housRulesSubject = PublishSubject<[HousRule]>()

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

    return Output(rules: housRules,
                  popViewController: popViewController,
                  presentBottomSheet: presentBottomSheet)
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
        }
      }.disposed(by: disposeBag)
  }
}
