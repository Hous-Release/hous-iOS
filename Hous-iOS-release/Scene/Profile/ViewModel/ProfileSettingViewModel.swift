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

final class ProfileAlarmSettingViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let profileRepository = ProfileRepositoryImp()
  let alarmSettingModelSubject = PublishSubject<AlarmSettingModel>()
  var currentData: AlarmSettingModel = AlarmSettingModel(isPushNotification: true, isNewRulesNotification: true, newTodoNotification: .allTodo, todayTodoNotification: .allTodo, notDoneTodoNotification: .allTodo, isBadgeNotification: true)
  // currentData initialize는 추후 서버 연결 했을 때 서버에서 Get 해온 값으로
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileAlarmSettingActionControl>
  }
  
  struct Output {
    let actionControl: Observable<ProfileAlarmSettingActionControl>
    let alarmSettingModel: Observable<AlarmSettingModel>
  }
  
  func transform(input: Input) -> Output {
    let actionControl = input.actionDetected.asObservable()
    let alarmSettingModelObservable = self.alarmSettingModelSubject.asObservable()
    
    input.actionDetected
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] action in
        guard let self = self else { return }
        switch action {
        case let .didTabButton(cellType: cellType, rawValue: rawValue):
          if cellType != .pushAlarm && self.currentData.isPushNotification == false {
            break
          }
          self.updateCurrentData(cellType: cellType, rawValue: rawValue)
          if cellType == .pushAlarm {
            input.actionDetected.onNext(.temporarilySetCellForSwitchAnimation)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
              self.alarmSettingModelSubject.onNext(self.currentData)
            }
          } else {
            self.alarmSettingModelSubject.onNext(self.currentData)
          }
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    alarmSettingModelObservable
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] data in
        self?.currentData = data
      })
      .disposed(by: disposeBag)

    return Output(actionControl: actionControl, alarmSettingModel: alarmSettingModelObservable)
  }
  
  private func updateCurrentData(cellType: AlarmSettingCellType, rawValue: Int) {
    switch cellType {
    case .pushAlarm:
      self.currentData.isPushNotification = {
        if rawValue == 0 { return false }
        else { return true }
      }()
      
    case .newRules:
      self.currentData.isNewRulesNotification = {
        if rawValue == 1 { return false }
        else { return true }
      }()
      
    case .newTodo:
      self.currentData.newTodoNotification = {
        switch rawValue {
        case 0:
          return .allTodo
        case 1:
          return .onlyInCharge
        case 2:
          return .alarmOff
        default:
          return .none
        }
      }()
      
    case .todayTodo:
      self.currentData.todayTodoNotification = {
        switch rawValue {
        case 0:
          return .allTodo
        case 1:
          return .onlyInCharge
        case 2:
          return .alarmOff
        default:
          return .none
        }
      }()
      
    case .notDoneTodo:
      self.currentData.notDoneTodoNotification = {
        switch rawValue {
        case 0:
          return .allTodo
        case 1:
          return .onlyInCharge
        case 2:
          return .alarmOff
        default:
          return .none
        }
      }()
      
    case .badgeAlarm:
      self.currentData.isBadgeNotification = {
        if rawValue == 1 { return false }
        else { return true }
      }()
      
    default:
      break
    }
  }
}
