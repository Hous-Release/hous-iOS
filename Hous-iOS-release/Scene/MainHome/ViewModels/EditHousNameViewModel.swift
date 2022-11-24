//
//  EditHousNameViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/17.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Network


final class EditHousNameViewModel: ViewModelType {
  
  private let maxCount = 8
  private let disposeBag = DisposeBag()
  
  //MARK: - Inputs
  struct Input {
    let roomName: Driver<String>
    let saveButtonDidTapped: Observable<String>
  }
  
  //MARK: - Outputs
  struct Output {
    var textCountLabelText: Driver<String>
    var updatedRoom: Driver<Void>
    let isValidText: Driver<Bool>
  }
  
  private let updateCompletedRelay = PublishRelay<Void>()
  
  func transform(input: Input) -> Output {
    
    let isValidText = input.roomName
      .map { str -> Bool in
        return str.count <= 8
      }
      .asDriver(onErrorJustReturn: false)
      
    
    let textCount = input.roomName.map({ [weak self] str -> String in
      guard let self = self else { return "" }
      return "\(str.count)/\(self.maxCount)"
    })
      .asDriver(onErrorJustReturn: "0/8")
    
    input.saveButtonDidTapped
      .subscribe (onNext: { str in
        NetworkService.shared.roomRepository.updateRoomName(
          RoomDTO.Request.updateRoomNameRequestDTO(name: str)
        ) { [weak self] res, err in
          if res?.status == 200 {
            self?.updateCompletedRelay.accept(())
          }
        }
      })
      .disposed(by: disposeBag)

    
    return Output(
      textCountLabelText: textCount,
      updatedRoom: updateCompletedRelay.asDriver(onErrorJustReturn: ()),
      isValidText: isValidText
    )
  }
  
}
