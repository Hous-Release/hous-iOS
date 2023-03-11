//
//  AddRuleViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/04.
//

import UIKit
import RxSwift
import RxCocoa
import Network

class AddRuleViewModel: ViewModelType {

  private let maxCount = 20

  struct Input {
    let navBackButtonDidTapped: Observable<Void>
    let viewDidTapped: Observable<UITapGestureRecognizer>
    let saveButtonDidTapped: Observable<[String]>
    let plusButtonDidTapped: Observable<Void>
    let textFieldEdit: Observable<String>
  }

  struct Output {
    let navBackButtonDidTapped: Driver<Void>
    let viewDidTapped: Driver<UITapGestureRecognizer>
    let savedCompleted: Driver<Int>
    let plusButtonDidTapped: Driver<Void>
    let isEnableStatusOfSaveButton: Driver<Bool>
    let textCountLabelText: Driver<String>
    let isEnteringRule: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    let savedCompleted = input.saveButtonDidTapped
      .flatMap { ruleNames -> Observable<Int> in
        return NetworkService.shared.ruleRepository.createRules(
          RuleDTO.Request.createRuleRequestDTO(ruleNames: ruleNames)
        )
      }
      .asDriver(onErrorJustReturn: 400)

    let isEnableStatusOfSaveButton = input.textFieldEdit.map { string in
      return string.trimmingCharacters(in: .whitespaces).count != 0
    }
      .asDriver(onErrorJustReturn: false)

    let textCount = input.textFieldEdit.map({ [weak self] str -> String in
      guard let self = self else { return "" }
      var strCount = str.count
      if strCount > 20 {
        strCount = 20
      }
      return "\(strCount)/\(self.maxCount)"
    })
      .asDriver(onErrorJustReturn: "0/\(maxCount)")

    let isEnteringRule = input.textFieldEdit
      .map { $0.count > 0 }
      .asDriver(onErrorJustReturn: false)

    return Output(
      navBackButtonDidTapped: input.navBackButtonDidTapped.asDriver(onErrorJustReturn: ()),
      viewDidTapped: input.viewDidTapped.asDriver(onErrorJustReturn: UITapGestureRecognizer()),
      savedCompleted: savedCompleted,
      plusButtonDidTapped: input.plusButtonDidTapped.asDriver(onErrorJustReturn: ()),
      isEnableStatusOfSaveButton: isEnableStatusOfSaveButton,
      textCountLabelText: textCount,
      isEnteringRule: isEnteringRule
    )
  }

}
