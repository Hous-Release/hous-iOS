//
//  EditRuleViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/02.
//

import Foundation
import RxSwift
import RxCocoa
import Network


final class EditRuleViewModel: ViewModelType {
  
  struct Input {
    let backButtonDidTap: Observable<Void>
    let saveButtonDidTap: Observable<[RuleWithIdViewModel]>
  }
  
  struct Output {
//    let isEmptyView: Driver<Bool>
    let saveCompleted: Driver<Void>
    let moveToRuleMainView: Driver<Void>
  }
  
  
  
  func transform(input: Input) -> Output {
    
//    let isEmptyView = input.saveButtonDidTap
//      .map { viewModels -> Bool in
//        print("viewModels 개수", viewModels.count, "👍👍👍👍")
//        return viewModels.count == 0
//      }
//      .asDriver(onErrorJustReturn: true)
    
    let ruleDTO = input.saveButtonDidTap
      .map { ruleViewModels -> [RuleDTO.Request.Rule] in
        var ruleDTO: [RuleDTO.Request.Rule] = []

        _ = ruleViewModels.map { ruleViewModel in
          let dto = RuleDTO.Request.Rule(id: ruleViewModel.id, name: ruleViewModel.name)
          ruleDTO.append(dto)
        }
        return ruleDTO
      }
    
    let ruleDriver = ruleDTO.flatMap { dto in
      NetworkService.shared.ruleRepository.updateRules(RuleDTO.Request.updateRulesRequestDTO(rules: dto))
    }
      .asDriver(onErrorJustReturn: ())
    
    let moveToRuleMainView = input.backButtonDidTap
      .asDriver(onErrorJustReturn: ())
      
    return Output(
      saveCompleted: ruleDriver,
      moveToRuleMainView: moveToRuleMainView
    )
    
  }
}
