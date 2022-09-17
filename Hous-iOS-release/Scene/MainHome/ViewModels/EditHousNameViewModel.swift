//
//  EditHousNameViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/17.
//

import Foundation
import RxSwift
import RxRelay



final class EditHousNameViewModel: ViewModelType {
  
  private let maxCount = 8
  private let disposeBag = DisposeBag()
  
  //MARK: - Inputs
  struct Input {
    let roomName: Observable<String>
    let saveButtonDidTapped: Observable<String?>
  }
  //MARK: - Outputs
  struct Output {
    var textCountLabelText = PublishRelay<String>()
    var text = BehaviorRelay<String>(value: "")
  }
  
  func transform(input: Input) -> Output {
    let output = Output()
    
    input.roomName
      .scan("") { [weak self] prev, next in
        
        if next.count > self!.maxCount {
          return prev
        } else {
          return next
        }
      }
      .subscribe(onNext: { [weak self] roomName in
        guard let self = self else { return }
        output.textCountLabelText.accept("\(roomName.count)/\(self.maxCount)")
        output.text.accept(roomName)
      })
      .disposed(by: disposeBag)
    
    
//    input.saveButtonDidTapped
//      .subscribe(onNext: { [weak self] _ in
//        guard let self = self else { return }
//
//
//      })
//      .disposed(by: disposeBag)
    
    return output
  }
  
}
