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
  static var event: PublishSubject<ProfileRepositoryEvent> { get }
  func getProfile()
  func putProfileEditInfo(data: ProfileEditModel)
}

public final class ProfileRepositoryImp: ProfileRepository {
  
  public static var event = PublishSubject<ProfileRepositoryEvent>()

  public func getProfile() {
    
    //MARK: Get Data
    
    NetworkService.shared.profileRepository.getProfileInfo { [weak self] res, err in
      guard let self = self else { return }
      guard let dto = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? "")
        ProfileRepositoryImp.event.onNext(.sendError(errorModel))
        return
      }
      
      //MARK: From DTO To Model
      
      var personalityColor: PersonalityColor
      switch dto.personalityColor {
      case "RED":
        personalityColor = .red
      case "GRAY":
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
        ProfileRepositoryImp.event.onNext(.getProfile(ProfileModel()))
        return
      }
      
      let birthdayPublic = dto.birthdayPublic
      
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "ko_KR")
      dateFormatter.timeZone = TimeZone(abbreviation: "KST")
      dateFormatter.dateFormat = "yyyy.MM.dd"
      
      let birthday = dateFormatter.date(from: dto.birthday ?? "")
      
      let userName = dto.nickname
      let userAge = Int(dto.age.filter {$0.isNumber}) ?? -1
      let userJob = dto.job
      let mbti = dto.mbti
      let statusMessage = dto.introduction
      let badgeLabel = dto.representBadge
      let badgeImageURL = dto.representBadgeImage
      let typeScores = [dto.testScore!.light, dto.testScore!.noise, dto.testScore!.smell, dto.testScore!.introversion, dto.testScore!.clean]
      
      ProfileRepositoryImp.event.onNext(.getProfile(ProfileModel(personalityColor: personalityColor, userName: userName, userAge: userAge, statusMessage: statusMessage, badgeImageURL: badgeImageURL, badgeLabel: badgeLabel, typeScores: typeScores, isEmptyView: false, birthday: birthday, birthdayPublic: birthdayPublic, userJob: userJob, mbti: mbti)))
    }
  }
  
  public func putProfileEditInfo(data: ProfileEditModel) {
    
    //MARK: Model To DTO
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    
    let birthday = dateFormatter.string(from: data.birthday)
    
    let introduction = (data.statusMessage != "") ? data.statusMessage : nil
    
    let isPublic = data.birthdayPublic
    
    let job = (data.job != "") ? data.job : nil
    
    let mbti = (data.mbti != "") ? data.mbti : nil
    
    let nickname = data.name
    
    let dto = ProfileDTO.Request.ProfileEditRequestDTO(birthday: birthday, introduction: introduction, isPublic: isPublic, job: job, mbti: mbti, nickname: nickname)

    
    //MARK: Put Data
    
    NetworkService.shared.profileRepository.putProfileEditInfo(dto) { [weak self] res, err in
      guard let self = self else { return }
      if (res?.status != 200) {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? ""
        )
        ProfileRepositoryImp.event.onNext(.sendError(errorModel))
        return
      }
      print("⭐️⭐️⭐️⭐️⭐️")
      ProfileRepositoryImp.event.onNext(.putProfile)
    }
  }
}


