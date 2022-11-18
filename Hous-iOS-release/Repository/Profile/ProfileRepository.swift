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
  case getHomieProfile(ProfileModel)
  case putRepresentingBadge
  case getBadges
  case postFeedBackBadge
  case getNotifications
  case getPersonality
  case putPersonality
  case getProfileTest(ProfileDetailModel)
  case patchPushAlarm
  case sendError(HouseErrorModel?)
}

public protocol ProfileRepository {
  static var event: PublishSubject<ProfileRepositoryEvent> { get }
  func getProfile()
  func getHomieProfile(id: String)
  func getProfileTestResult(color: PersonalityColor)
  func putProfileEditInfo(data: ProfileEditModel)
}

public final class ProfileRepositoryImp: ProfileRepository {
  
  public static var event = PublishSubject<ProfileRepositoryEvent>()
  
  public func getProfileTestResult(color: PersonalityColor) {
    
    //MARK: Request Query param Set and Get Data
    var requestDTO : ProfileDTO.Request.ProfileTestResultDTO {
      switch color {
      case .red:
        return ProfileDTO.Request.ProfileTestResultDTO(color: "RED")
      case .blue:
        return ProfileDTO.Request.ProfileTestResultDTO(color: "BLUE")
      case .yellow:
        return ProfileDTO.Request.ProfileTestResultDTO(color: "YELLOW")
      case .green:
        return ProfileDTO.Request.ProfileTestResultDTO(color: "GREEN")
      case .purple:
        return ProfileDTO.Request.ProfileTestResultDTO(color: "PURPLE")
      case .none:
        return ProfileDTO.Request.ProfileTestResultDTO(color: "GRAY")
      }
    }
    
    
    
    NetworkService.shared.profileRepository.getProfileTestResultInfo(dto: requestDTO) { res, err in
      guard let dto = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? "")
        ProfileRepositoryImp.event.onNext(.sendError(errorModel))
        return
      }
     
      
      //MARK: From DTO To Model
      var personalityType: PersonalityColor
      switch dto.color {
      case "RED":
        personalityType = .red
      case "BLUE":
        personalityType = .blue
      case "YELLOW":
        personalityType = .yellow
      case "GREEN":
        personalityType = .green
      case "PURPLE":
        personalityType = .purple
      default:
        personalityType = .none
      }
      
      ProfileRepositoryImp.event.onNext(.getProfileTest(ProfileDetailModel(personalityType: personalityType, badPersonalityImageURL: dto.badPersonalityImageURL, badPersonalityName: dto.badPersonalityName, goodPersonalityImageURL: dto.goodPersonalityImageURL, goodPersonalityName: dto.goodPersonalityName, imageURL: dto.imageURL, name: dto.name, recommendTitle: dto.recommendTitle, recommendTodo: dto.recommendTodo, title: dto.title, description: dto.dataDescription)))
    }
  }

  public func getProfile() {
    
    //MARK: Get Data
    
    NetworkService.shared.profileRepository.getProfileInfo { res, err in
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
      var isEmptyView = false
      switch dto.personalityColor {
      case "RED":
        personalityColor = .red
      case "BLUE":
        personalityColor = .blue
      case "GRAY":
        personalityColor = .yellow
      case "GREEN":
        personalityColor = .green
      case "PURPLE":
        personalityColor = .purple
      default:
        personalityColor = .none
        isEmptyView = true
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
      let badgeLabel: String? = dto.representBadge
      let badgeImageURL: String? = dto.representBadgeImage
      let typeScores = [dto.testScore!.light, dto.testScore!.noise, dto.testScore!.smell, dto.testScore!.introversion, dto.testScore!.clean]
      
      ProfileRepositoryImp.event.onNext(.getProfile(ProfileModel(personalityColor: personalityColor, userName: userName, userAge: userAge, statusMessage: statusMessage, badgeImageURL: badgeImageURL, badgeLabel: badgeLabel, typeScores: typeScores, isEmptyView: isEmptyView, birthday: birthday, birthdayPublic: birthdayPublic, userJob: userJob, mbti: mbti)))
    }
  }
  
  public func getHomieProfile(id: String) {
    
    //MARK: Get Data
    
    NetworkService.shared.profileRepository.getHomieProfileInfo(id: id) { res, err in
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
      var isEmptyView = false
      switch dto.personalityColor {
      case "RED":
        personalityColor = .red
      case "BLUE":
        personalityColor = .blue
      case "YELLOW":
        personalityColor = .yellow
      case "GRAY":
        personalityColor = .green
      case "PURPLE":
        personalityColor = .purple
      default:
        personalityColor = .none
        isEmptyView = true
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
      let badgeLabel: String? = dto.representBadge
      let badgeImageURL: String? = dto.representBadgeImage
      let typeScores = [dto.testScore!.light, dto.testScore!.noise, dto.testScore!.smell, dto.testScore!.introversion, dto.testScore!.clean]
      
      ProfileRepositoryImp.event.onNext(.getHomieProfile(ProfileModel(personalityColor: personalityColor, userName: userName, userAge: userAge, statusMessage: statusMessage, badgeImageURL: badgeImageURL, badgeLabel: badgeLabel, typeScores: typeScores, isEmptyView: isEmptyView, birthday: birthday, birthdayPublic: birthdayPublic, userJob: userJob, mbti: mbti)))
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
    
    NetworkService.shared.profileRepository.putProfileEditInfo(dto) { res, err in
      if (res?.status != 200) {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? ""
        )
        ProfileRepositoryImp.event.onNext(.sendError(errorModel))
        return
      }
      ProfileRepositoryImp.event.onNext(.putProfile)
    }
  }
}


