//
//  ProfileDTO.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

import UIKit

enum PersonalityColor: Codable {
  case red
  case blue
  case yellow
  case green
  case purple
  case none
  
  var graphBackgroundColor: UIColor {
    switch self {
    case .red:
      return Colors.redB1.color
    case .blue:
      return Colors.blueL1.color
    case .yellow:
      return Colors.yellowB1.color
    case .green:
      return Colors.greenB1.color
    case .purple:
      return Colors.purpleB1.color
    case .none:
      return .white
    }
  }
  
  var graphColor: UIColor {
    switch self {
    case .red:
      return Colors.red.color
    case .blue:
      return Colors.blue.color
    case .yellow:
      return Colors.yellow.color
    case .green:
      return Colors.green.color
    case .purple:
      return Colors.purple.color
    case .none:
      return .white
    }
  }
  
  var textColor: UIColor {
    switch self {
    case .red:
      return Colors.red.color
    case .blue:
      return Colors.blue.color
    case .yellow:
      return Colors.yellow.color
    case .green:
      return Colors.green.color
    case .purple:
      return Colors.purple.color
    case .none:
      return .white
    }
  }
  
  var personalityText : String {
    switch self {
    case .red:
      return "슈퍼 팔로워 셋돌이"
    case .blue:
      return "룸메 맞춤형 네각이"
    case .yellow:
      return "늘 행복한 동글이"
    case .purple:
      return "하이레벨 오각이"
    case .green:
      return "룰 세터 육각이"
    case .none:
      return ""
    }
  }
}

public struct ProfileModel: Encodable, Equatable {
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
    self.isEmptyView = true
    self.birthday = birthday
    self.birthdayPublic = birthdayPublic
    self.userJob = userJob
    self.mbti = mbti
  }
}

public struct PersonalityAttributeDescription {
  let attributeName: String
  let attributeDescription: String
}

public let personalityAttributeDescriptions: [PersonalityAttributeDescription] = [
  PersonalityAttributeDescription(attributeName: "빛", attributeDescription: "빛에 예민한 사람들은 보통 어쩌구 저쩌구를 하는 어찌 뭐뭐를 조심하면 좋을지"),
  PersonalityAttributeDescription(attributeName: "소음", attributeDescription: "소음에 예민한 사람들은 제발 밤에 음악 틀고 춤 좀 추지 말아주세요 제발"),
  PersonalityAttributeDescription(attributeName: "냄새", attributeDescription: "냄새에 민감한 사람들을\n위해서라도 밤 늦게 음식을 먹지 않지만 치킨은 먹지."),
  PersonalityAttributeDescription(attributeName: "내향", attributeDescription: "사람들이랑 놀고 싶은 마음은 이해하지만 기 너무 안 빨리게만 조심 좀"),
  PersonalityAttributeDescription(attributeName: "정리정돈", attributeDescription: "내가 할 소리는 아니지만 정리 정돈에 예민한 사람들을 위해 정리정돈 좀 하자..")]

enum ProfileActionControl {
  case didTabAlarm
  case didTabSetting
  case didTabEdit
  case didTabDetail
  case didTabRetry
  case none
}


