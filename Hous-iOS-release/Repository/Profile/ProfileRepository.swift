//
//  ProfileRepository.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/30.
//

import Foundation
import Network
import RxSwift
import RxCocoa

public enum ProfileRepositoryEvent {
  case getProfile(ProfileModel)
  case putProfile
  case deleteProfile
  case getHomieProfile
  case putRepresentingBadge
  case getBadges
  case postFeedBackBadge
  case getNotifications
  case getPersonality
  case putPersonality
  case getPersonalityTest
  case patchPushAlarm
  case sendError(HouseErrorModel?)
}

public protocol ProfileRepository {
  var event: PublishSubject<ProfileRepositoryEvent> { get }
  func getProfile()
}

public final class ProfileRepositoryImp: ProfileRepository {
  
  public var event = PublishSubject<ProfileRepositoryEvent>()
  
  public func getProfile() {
    
    //MARK: Get Data
    
    NetworkService.shared.profileRepository.getProfileInfo { [weak self] res, err in
      guard let self = self else { return }
      guard let dto = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? "")
        self.event.onNext(.sendError(errorModel))
        return
      }
      
      //MARK: From DTO To Model
      
      var personalityColor: PersonalityColor
      switch dto.personalityColor {
      case "RED":
        personalityColor = .red
      case "BLUE":
        personalityColor = .blue
      case "YELLOW":
        personalityColor = .yellow
      case "GREEN":
        personalityColor = .green
      case "PURPLE":
        personalityColor = .purple
      default:
        personalityColor = .none
      }
      
      if (personalityColor == .none) {
        self.event.onNext(.getProfile(ProfileModel()))
        return
      }
      
      let userName = dto.nickname
      let statusMessage = dto.introduction ?? "자기소개를 수정해서 룸메이트들에게 나를 소개해보세요!"
      let badgeLabel = dto.representBadge ?? "내 대표 배지"
      let badgeImageURL = dto.representBadgeImage
      let typeScores = [dto.testScore!.light, dto.testScore!.noise, dto.testScore!.smell, dto.testScore!.introversion, dto.testScore!.clean]
      
      var hashTags : [String] = []
      
      if (dto.birthdayPublic) {
        [dto.age, dto.birthday, dto.mbti, dto.job].forEach { element in
          if (element != nil) {
            hashTags.append(element!)
          }
        }
      } else {
        [dto.age, dto.mbti, dto.job].forEach { element in
          if (element != nil) {
            hashTags.append(element!)
          }
        }
      }
      
      self.event.onNext(.getProfile(ProfileModel(personalityColor: personalityColor, userName: userName, statusMessage: statusMessage, badgeImageURL: badgeImageURL, badgeLabel: badgeLabel, hashTags: hashTags, typeScores: typeScores, isEmptyView: false)))
    }
  }
}


