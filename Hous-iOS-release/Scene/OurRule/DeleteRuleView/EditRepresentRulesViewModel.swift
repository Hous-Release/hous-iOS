//
//  EditRepresentRulesViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/04.
//

import Foundation
import RxSwift
import RxCocoa
import Network

 final class EditRepresentRulesViewModel: ViewModelType {
  struct Input {
    let saveButtonDidTap: Observable<[Int]>
    let navBackButtonDidTapped: Observable<Void>
    let ruleDidTap: Observable<Int>
  }

  struct Output {
    let savedComplete: Driver<Void>
    let moveToMainRuleView: Driver<Bool>
    let representCountExceeded: PublishSubject<Bool>
  }

   private let maxRepresentCount = 3

   private let rules: [HousRule] = []

   var selectedRulesId: [Int] = []

   private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let representCountExceeded = PublishSubject<Bool>()
    let updateRequest = PublishSubject<[Int]>()

    input.ruleDidTap
      .subscribe(onNext: { [weak self] ruleId in
        guard let self else { return }
        if self.selectedRulesId.contains(ruleId) {
          guard let index = self.selectedRulesId.firstIndex(of: ruleId) else { return }
          self.selectedRulesId.remove(at: index)
          return
        }
        self.selectedRulesId.append(ruleId)
      })
      .disposed(by: disposeBag)

    input.saveButtonDidTap
      .subscribe(onNext: { ruleIds in
        if ruleIds.count > self.maxRepresentCount {
          representCountExceeded.onNext(true)
          return
        }
        updateRequest.onNext(ruleIds)
      })
      .disposed(by: disposeBag)

    let naviBackButtonDidTap = input.navBackButtonDidTapped
      .map { _ in
        return !self.selectedRulesId.isEmpty
      }
      .asDriver(onErrorJustReturn: false)

    let savedComplete = updateRequest
      .flatMap { ruleIds in
        self.selectedRulesId = ruleIds
      let requestDTO = RuleDTO.Request.RepresentRulesRequestDTO(rules: ruleIds)
      return NetworkService.shared
        .ruleRepository
        .updateRepresentRules(requestDTO)
    }
      .asDriver(onErrorJustReturn: ())

    return Output(
      savedComplete: savedComplete,
      moveToMainRuleView: naviBackButtonDidTap,
      representCountExceeded: representCountExceeded
    )

  }
 }
