//
//  ProfileSettingModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/04.
//

import Foundation


enum ProfileSettingActionControl {
  case didTabAlarmSetting
  case didTabAgreement
  case didTabFeedBack
  case didTabLogout
  case didTabLeavingRoom
  case didTabWithdraw
  case didTabBack
  case didTabLicense
}

enum ProfileAlarmSettingActionControl {
  case settingInfoChanged(data: AlarmSettingModel)
  case didTabBack
  case didTabButton(cellType: AlarmSettingCellType, rawValue: Int)
  case temporarilySetCellForSwitchAnimation
  case none
}

enum TodoNotificationMode {
  case allTodo
  case onlyInCharge
  case alarmOff
  case none
}

public struct AlarmSettingModel: Equatable {
  var isPushNotification: Bool
  var isNewRulesNotification: Bool
  var newTodoNotification: TodoNotificationMode
  var todayTodoNotification: TodoNotificationMode
  var notDoneTodoNotification: TodoNotificationMode
  var isBadgeNotification: Bool
  
  init() {
    self.isPushNotification = false
    self.isNewRulesNotification = false
    self.newTodoNotification = .none
    self.todayTodoNotification = .none
    self.notDoneTodoNotification = .none
    self.isBadgeNotification = false
  }
  
  init(isPushNotification: Bool, isNewRulesNotification: Bool, newTodoNotification: TodoNotificationMode, todayTodoNotification: TodoNotificationMode, notDoneTodoNotification: TodoNotificationMode, isBadgeNotification: Bool) {
    self.isPushNotification = isPushNotification
    self.isNewRulesNotification = isNewRulesNotification
    self.newTodoNotification = newTodoNotification
    self.todayTodoNotification = todayTodoNotification
    self.notDoneTodoNotification = notDoneTodoNotification
    self.isBadgeNotification = isBadgeNotification
  }
}

enum AlarmSettingButtonState {
  case disableSelected
  case enableSelected
  case unselected
}

public enum AlarmSettingCellType {
  case newRules
  case newTodo
  case todayTodo
  case notDoneTodo
  case badgeAlarm
  case pushAlarm
  case none
}

