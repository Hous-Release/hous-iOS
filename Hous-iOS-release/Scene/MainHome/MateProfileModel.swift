//
//  MateProfileModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit

public struct MateProfileModel: Encodable, Equatable {
  var personalityColor: PersonalityColor
  var userName, statusMessage, badgeImageURL, badgeLabel: String?
  var typeScores: [Double]
  var isEmptyView: Bool
  var birthday: Date?
  var birthdayPublic: Bool
  var userJob: String?
  var mbti: String?
  var userAge: Int?
  
  init() {
    personalityColor = .red
    userName = "default"
    userAge = 0
    userJob = ""
    statusMessage = "default\ndefault"
    badgeImageURL = ""
    badgeLabel = "default"
    typeScores = [10, 10, 10, 10, 10]
    isEmptyView = true
    birthdayPublic = false
    mbti = ""
  }
  
  init(personalityColor: PersonalityColor, userName: String?, userAge: Int?, statusMessage: String?, badgeImageURL: String?, badgeLabel: String?, typeScores: [Double], isEmptyView: Bool, birthday: Date?, birthdayPublic: Bool, userJob: String?, mbti: String?) {
    self.personalityColor = personalityColor
    self.userName = userName
    self.userAge = userAge
    self.statusMessage = statusMessage
    self.badgeImageURL = badgeImageURL
    self.badgeLabel = badgeLabel
    self.typeScores = typeScores
    self.isEmptyView = isEmptyView
    self.birthday = birthday
    self.birthdayPublic = birthdayPublic
    self.userJob = userJob
    self.mbti = mbti
  }
}

//enum ProfileActionControl {
//  case didTabAlarm
//  case didTabSetting
//  case didTabEdit
//  case didTabDetail
//  case didTabTest
//  case didTabBadge
//  case network
//  case none
//}


