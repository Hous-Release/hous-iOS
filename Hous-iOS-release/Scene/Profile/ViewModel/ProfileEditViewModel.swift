//
//  ProfileEditViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/07.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileEditViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let profileData = ProfileModel()
  private let originalData: ProfileEditModel
  var modifiedData: ProfileEditModel
  var isModifiedData = false
  
  init(data: ProfileModel) {
    let dateComponents = DateComponents(timeZone: TimeZone(identifier: "ko-KR"), year: 1800, month: 6, day: 3)
    originalData = ProfileEditModel(
      name: data.userName ?? "",
      birthday: data.birthday,
      mbti: data.mbti ?? "",
      job: data.userJob ?? "",
      statusMessage: data.statusMessage ?? "",
      birthdayPublic: data.birthdayPublic
    )
    modifiedData = originalData
  }
  
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileEditActionControl>
  }
  
  struct Output {
    let actionControl: Observable<ProfileEditActionControl>
    let isModifiedObservable: Observable<Bool>
  }
  
  func transform(input: Input) -> Output {
    
    let actionControl = input.actionDetected.asObservable()
    let isModified = PublishSubject<Bool>()
    let isModifiedObservable = isModified.asObservable()
    
    actionControl
      .bind(onNext: { [weak self] action in
        guard let self = self else { return }
        switch action {
        case let .nameTextFieldEdited(text):
          self.modifiedData.name = text
        case let .birthdayTextFieldEdited(date):
          self.modifiedData.birthday = date
        case let .birthdayPublicEdited(isPublic):
          self.modifiedData.birthdayPublic = isPublic
        case let .mbtiTextFieldEdited(text):
          self.modifiedData.mbti = text
        case let .jobTextFieldEdited(text):
          self.modifiedData.job = text
        case let .statusTextViewEdited(text):
          self.modifiedData.statusMessage = text
        default:
          break
        }
        if (self.modifiedData == self.originalData) {
          isModified.onNext(false)
          self.isModifiedData = false
        } else {
          isModified.onNext(true)
          self.isModifiedData = true
        }
      })
      .disposed(by: disposeBag)
    
    return Output(
      actionControl: actionControl,
      isModifiedObservable: isModifiedObservable
    )
  }
  
  
}
