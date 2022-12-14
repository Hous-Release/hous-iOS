//
//  ProfileAlarmViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileAlarmViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let profileRepository = ProfileRepositoryImp()
  private let actionControl = PublishSubject<ProfileAlarmActionControl>()
  let alarmModelSubject = PublishSubject<AlarmModel>()
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileAlarmActionControl>
  }
  
  struct Output {
    let actionControl: Observable<ProfileAlarmActionControl>
    let alarmModel: Observable<AlarmModel>
  }
  
  func transform(input: Input) -> Output {
    let actionControl = input.actionDetected.asObservable()
    let alarmModelObservable = self.alarmModelSubject.asObservable()
    return Output(actionControl: actionControl, alarmModel: alarmModelObservable)
  }
}

