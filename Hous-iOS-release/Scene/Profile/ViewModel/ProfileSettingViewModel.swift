//
//  ProfileSettingViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/04.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileSettingViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let profileRepository = ProfileRepositoryImp()
  private let actionControl = PublishSubject<ProfileSettingActionControl>()
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileSettingActionControl>
  }
  
  struct Output {
    let actionControl: Observable<ProfileSettingActionControl>
  }
  
  func transform(input: Input) -> Output {
    let actionControl = input.actionDetected.asObservable()
    return Output(actionControl: actionControl)
  }
}