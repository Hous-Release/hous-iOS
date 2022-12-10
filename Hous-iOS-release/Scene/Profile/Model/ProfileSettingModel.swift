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
}

enum ProfileAlarmSettingActionControl {
  case settingInfoChange
  case didTabBack
}

enum TodoNotificationMode {
  case allTodo
  case onlyInCharge
  case alarmOff
}

public struct AlarmSettingModel {
  var isPushNotification: Bool
  var isNewRulesNotification: Bool
  var newTodoNotification: TodoNotificationMode
  var todayTodoNotification: TodoNotificationMode
  var notDoneTodoNotification: TodoNotificationMode
  var isBadgeNotification: Bool
}

enum AlarmSettingButtonState {
  case disableSelected
  case enableSelected
  case unselected
}

enum AlarmSettingCellType {
  case newRules
  case newTodo
  case todayTodo
  case notDoneTodo
  case badgeAlarm
}
