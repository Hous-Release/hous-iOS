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
    let savedCompleted: Driver<Void>
    let plusButtonDidTapped: Driver<Void>
    let isEnableStatusOfSaveButton: Driver<Bool>
  }
  
  func transform(input: Input) -> Output {
    let savedCompleted = input.saveButtonDidTapped
      .map { ruleNames in
        //TODO: Network - Create Rules
        print(ruleNames, "👍👍👍👍")
      }
      .asDriver(onErrorJustReturn: ())
    
    let isEnableStatusOfSaveButton = input.textFieldEdit.map { string in
      return string.count != 0
    }
      .asDriver(onErrorJustReturn: false)
    
    return Output(
      navBackButtonDidTapped: input.navBackButtonDidTapped.asDriver(onErrorJustReturn: ()),
      viewDidTapped: input.viewDidTapped.asDriver(onErrorJustReturn: UITapGestureRecognizer()),
      savedCompleted: savedCompleted,
      plusButtonDidTapped: input.plusButtonDidTapped.asDriver(onErrorJustReturn: ()),
      isEnableStatusOfSaveButton: isEnableStatusOfSaveButton
    )
  }
  
}
