//
//  DeleteRuleViewModel.swift
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
  }

  struct Output {
    let savedComplete: Driver<Void>
    let moveToMainRuleView: Driver<Void>
  }

  func transform(input: Input) -> Output {
    let savedComplete = input.saveButtonDidTap.flatMap { ruleId in
//      return NetworkService.shared
//        .ruleRepository
//        .deleteRules(
//        RuleDTO.Request.deleteRulesRequestDTO(rulesIdList: ruleId)
//        )
    }
    .asDriver(onErrorJustReturn: ())

    return Output(
      savedComplete: savedComplete,
      moveToMainRuleView: input.navBackButtonDidTapped.asDriver(onErrorJustReturn: ())
    )

  }
 }
