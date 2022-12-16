//
//  ProfileAlarmModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/12/14.
//

import UIKit

public enum ProfileAlarmActionControl {
  case didTabBack
  case willFetchNewData
}

public struct AlarmModel {
  let content: String
  let createdAt: String
  let isRead: Bool
  let notificationId: Int
  let type: NotificationType
}

public enum NotificationType {
  case todo
  case rules
  case badge
}
