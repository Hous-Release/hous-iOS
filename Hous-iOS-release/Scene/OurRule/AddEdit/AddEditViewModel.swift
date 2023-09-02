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
    let navBackButtonDidTapped: Observable<Void>
    let addButtonDidTap: Observable<CreateRuleRequestDTO>
  }

  struct Output {
    let navBackButtonDidTapped: Driver<Void>
    let createdRule: Driver<Int>
  }

  func transform(_ input: Input) -> Output {
    let savedCompleted = input.addButtonDidTap
      .flatMap { dto in
        let images = dto.images.map { $0.resize() }
        if let ruleId = dto.ruleId {
          return NetworkService.shared.ruleRepository
            .updateRule(.init(name: dto.name, description: dto.description), ruleId: ruleId, images: images)
        }

        return NetworkService.shared.ruleRepository
          .createRules(.init(name: dto.name, description: dto.description), images: images)
      }
      .asDriver(onErrorJustReturn: 400)

    let backButtonTapped = input.navBackButtonDidTapped.asDriver(onErrorJustReturn: ())

    return Output(navBackButtonDidTapped: backButtonTapped,
                  createdRule: savedCompleted)
  }

}
