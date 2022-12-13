//
//  ProfileDTO.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

import UIKit

public enum PersonalityColor: Codable {
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
    self.isEmptyView = isEmptyView
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
  PersonalityAttributeDescription(attributeName: "빛", attributeDescription: "빛 수치가 높은 호미는\n소등 시간이 중요해요!\n이 호미를 위해 스탠드는\n꼭 끄도록 해요!"),
  PersonalityAttributeDescription(attributeName: "소음", attributeDescription: "소음 수치가 높은 호미를 \n위해 영상/전화를 보거나\n할 땐 이어폰이 필수!"),
  PersonalityAttributeDescription(attributeName: "냄새", attributeDescription: "냄새 수치가 높은 호미를\n위해 음식은 꼭 부엌에서\n먹어요! 아, 환기도 틈틈히!\n잊지말아요~"),
  PersonalityAttributeDescription(attributeName: "내향", attributeDescription: "내향 수치가 높은 호미는 \n혼자만의 시간이 필요해요.\n충전 중이니 조금만 기다려주세요!"),
  PersonalityAttributeDescription(attributeName: "정리정돈", attributeDescription: "청소 전 정리정돈 수치가\n높은 호미들의 이야기를\n들어주면 더 나은\n공동생활이 가능할 거예요~")]

enum ProfileActionControl {
  case didTabAlarm
  case didTabSetting
  case didTabEdit
  case didTabDetail
  case didTabTest
  case didTabBadge
  case network
  case none
}


