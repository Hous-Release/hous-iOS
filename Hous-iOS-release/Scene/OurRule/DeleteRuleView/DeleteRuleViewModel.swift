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

class DeleteRuleViewModel: ViewModelType {
  struct Input {
    let deleteButtonDidTapped: Observable<[Int]>
    let navBackButtonDidTapped: Observable<Void>
  }
  
  struct Output {
    let deletedCompleted: Driver<Void>
    let moveToMainRuleView: Driver<Void>
  }
  
  func transform(input: Input) -> Output {
    let deletedCompleted = input.deleteButtonDidTapped.flatMap { ruleId in
      return NetworkService.shared.ruleRepository.deleteRules(RuleDTO.Request.deleteRulesRequestDTO(rulesIdList: ruleId))
    }
    .asDriver(onErrorJustReturn: ())
     
    
    return Output(
      deletedCompleted: deletedCompleted,
      moveToMainRuleView: input.navBackButtonDidTapped.asDriver(onErrorJustReturn: ())
    )
    
  }
}
