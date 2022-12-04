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
  }
  
  struct Output {
    let actionControl: PublishSubject<ProfileSettingActionControl>
  }
  
  func transform(input: Input) -> Output {
    return Output(actionControl: actionControl)
  }
}
