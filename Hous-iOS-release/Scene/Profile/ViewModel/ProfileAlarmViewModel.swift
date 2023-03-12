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
  let profileRepository = ProfileRepositoryImp()
  private let actionControl = PublishSubject<ProfileAlarmActionControl>()
  private let isSpinnerOnSignal = PublishSubject<Bool>()
  let alarmModelSubject = PublishSubject<[AlarmModel]>()
  var currentData: [AlarmModel] = []
  var currentNextCursor: Int = -2
  var isLoading = false

  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileAlarmActionControl>
  }

  struct Output {
    let actionControl: Observable<ProfileAlarmActionControl>
    let alarmModel: Observable<[AlarmModel]>
    let isSpinnerOnSignal: Observable<Bool>
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
          self.isSpinnerOnSignal.onNext(false)
          self.isLoading = false
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
    profileRepository.getAlarmInfo(lastNotificationId: Int(Int64.max), size: 20)

    // Action
    let actionControl = input.actionDetected.asObservable()
    let alarmModelObservable = self.alarmModelSubject.asObservable()
    let isSpinnerOnSignalObservable = self.isSpinnerOnSignal.asObservable()

    actionControl
      .observe(on: MainScheduler.asyncInstance)
      .filter({ _ in return !self.isLoading && self.currentNextCursor != -1 })
      .bind(onNext: { [weak self] action in
        guard let self = self else { return }
        switch action {
        case .willFetchNewData:
          self.isLoading = true
          self.profileRepository.getAlarmInfo(lastNotificationId: self.currentNextCursor, size: 20)
          self.isSpinnerOnSignal.onNext(true)
        default:
          break
        }
      })
      .disposed(by: disposeBag)

    return Output(actionControl: actionControl, alarmModel: alarmModelObservable,
                  isSpinnerOnSignal: isSpinnerOnSignalObservable)
  }
}
