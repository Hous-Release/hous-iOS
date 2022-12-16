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
  let alarmModelSubject = PublishSubject<[AlarmModel]>()
  var currentData: [AlarmModel] = []
  var currentNextCursor: Int = -2
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileAlarmActionControl>
  }
  
  struct Output {
    let actionControl: Observable<ProfileAlarmActionControl>
    let alarmModel: Observable<[AlarmModel]>
  }
  
  init() {
    ProfileRepositoryImp.event
      .subscribe(onNext: { [weak self] event in
        guard let self = self else { return }
        switch event {
        case let .getAlarmInfo((alarmModelList, nextCursor)):
          self.currentData += alarmModelList
          self.currentNextCursor = nextCursor
          self.alarmModelSubject.onNext(self.currentData)
        case .sendError:
          print("😭 Network Error..😭")
          print(event)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
  }
  
  func transform(input: Input) -> Output {
    // Data
    profileRepository.getAlarmInfo(lastNotificationId: Int(Int64.max), size: 10)
    
    // Action
    let actionControl = input.actionDetected.asObservable()
    let alarmModelObservable = self.alarmModelSubject.asObservable()
    
    return Output(actionControl: actionControl, alarmModel: alarmModelObservable)
  }
}

