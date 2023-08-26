//
//  AddEditViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import Network

final class AddEditViewModel {

  // MARK: - Inputs
  struct Input {
    let addButtonDidTap: Observable<CreateRuleRequestDTO>
  }

  struct Output {
    let createdRule: Driver<Int>
  }

  func transform(_ input: Input) -> Output {
    let savedCompleted = input.addButtonDidTap
      .flatMap { dto in
        return NetworkService.shared.ruleRepository.createRules(.init(name: dto.name, description: dto.description), images: dto.images)
      }
      .asDriver(onErrorJustReturn: 400)
    //      .flatMap { ruleNames -> Observable<Int> in
    //        return NetworkService.shared.ruleRepository.createRules(
    //          RuleDTO.Request.createRuleRequestDTO(ruleNames: ruleNames)
    //        )
    //      }
    //      .asDriver(onErrorJustReturn: 400)
    return Output(createdRule: savedCompleted)
  }

}
