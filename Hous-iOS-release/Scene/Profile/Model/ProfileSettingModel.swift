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
  case pushAlarm
  case none
}

public struct AlarmSettingCellData {
  static var data = AlarmSettingModel(isPushNotification: true, isNewRulesNotification: true, newTodoNotification: .allTodo, todayTodoNotification: .allTodo, notDoneTodoNotification: .allTodo, isBadgeNotification: true)
}
