//
//  ProfileResponseDTO.swift
//  
//
//  Created by 이의진 on 2022/10/30.
//  Created by 김민재 on 2022/11/08.


import Foundation

public extension ProfileDTO.Response {
  
  struct VoidDTO: Codable {
    
  }
  
  // MARK: Get Alarm
  struct GetAlarmResponseDTO: Codable {
    public let contents: [GetAlarmContent]
    public let nextCursor, totalElements: Int
  }
  
  struct GetAlarmContent: Codable {
    public let content, createdAt: String
    public let isRead: Bool
    public let notificationId: Int
    public let type: String
  }
  
  // MARK: Get Profile
  struct ProfileGetResponseDTO : Codable {
    public let birthday: String?
    public let birthdayPublic: Bool
    public let age: String
    public let introduction, job, mbti, nickname, personalityColor, representBadge, representBadgeImage: String?
    public let testScore: TestScore?
  }
  
  struct TestScore: Codable {
    public let clean, introversion, light, noise, smell: Double
  }
  
  // MARK: Get Alarm Setting Info
  struct GetAlarmSettingResponseDTO: Codable {
    public let badgePushStatus: String
    public let isPushNotification: Bool
    public let newTodoPushStatus, remindTodoPushStatus, rulesPushStatus, todayTodoPushStatus: String
  }
  
  // MARK: Save Alarm Setting Info
  struct SaveAlarmSettingResponseDTO: Codable {
    public let data: String
    public let message: String
    public let status: Int
    public let success: Bool
  }
  
  // MARK: - GET Badge
  struct getBadgesResponseDTO: Decodable {
    public let badges: [Badge]
    public let representBadge: RepresentBadge?
  }
  
  // MARK: - Badge
  struct Badge: Decodable {
    public let badgeID: Int
    public let badgeDescription: String
    public let imageURL: String
    public let isAcquired: Bool
    public let isRead: Bool
    public let name: String
    
    enum CodingKeys: String, CodingKey {
      case badgeID = "badgeId"
      case badgeDescription = "description"
      case imageURL = "imageUrl"
      case isAcquired, isRead, name
    }
  }
  
  // MARK: - RepresentBadge
  struct RepresentBadge: Decodable {
    public let badgeID: Int
    public let imageURL: String
    public let name: String
    
    enum CodingKeys: String, CodingKey {
      case badgeID = "badgeId"
      case imageURL = "imageUrl"
      case name
    }
  }
  
  struct updateRepresentBadge: Decodable {
    
  }
  //MARK: ProfileEdit
  
  struct ProfileEditResponseDTO: Codable {
    public let data: String
    public let message: String
    public let status: Int
    public let success: Bool
  }
  
  //MARK: ProfileTest
  struct ProfileTestResponseDTO: Codable {
    public let question: [String]
    public let questionNum: Int
    public let questionImg: String
    public let questionType: String
    public let answers: [[String]]
    
    enum CodingKeys: String, CodingKey {
      case question, questionType, answers
      case questionNum = "index"
      case questionImg = "imageUrl"
    }
  }
  
  struct ProfileTestSaveResponseDTO: Codable {
    public let color: String
  }
  
  struct ProfileTestResultResponseDTO: Codable {
    public let name: String
    public let imageURL: String
    public let color, title: String
    public let dataDescription: [String]
    public let recommendTitle: String
    public let recommendTodo: [String]
    public let goodPersonalityName: String
    public let goodPersonalityImageURL: String
    public let badPersonalityName: String
    public let badPersonalityImageURL: String
    
    enum CodingKeys: String, CodingKey {
      case name
      case imageURL = "imageUrl"
      case color, title
      case dataDescription = "description"
      case recommendTitle, recommendTodo, goodPersonalityName
      case goodPersonalityImageURL = "goodPersonalityImageUrl"
      case badPersonalityName
      case badPersonalityImageURL = "badPersonalityImageUrl"
    }
  }
}
