//
//  ProfileViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/09/28.
//

//Reference Link  : https://mildwhale.github.io/2020-04-16-mvvm-with-input-output/

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileActionControl>
  }
  
  struct Output {
    let profileModel: Observable<ProfileModel>
    let actionControl: Observable<ProfileActionControl>
  }
  
  
  func transform(input: Input) -> Output {
    
    // Data
    // 서버 연결 후
    // Repository로부터 받아온 profileModel data를 집어넣는다.
    
    // Using Dummy Data
    
    let profileModel = ProfileModel (
      personalityColor: .red,
      userName: "최인영",
      userJob: "대학생",
      statusMessage: "집가고싶다.",
      badgeImageURL: "dummyData",
      badgeLabel: "뱃지이름",
      hashTags: ["23세", "10.31", "ENFP", "대학생"],
      typeScores: [60, 70, 70, 70, 70],
      isEmptyView: false)
    
    // end dummy
    
    let profileModelObservable = Observable.just(profileModel)
    
    // Action
    
    let actionControl = input.actionDetected.asObservable()
    
    return Output(
      profileModel: profileModelObservable,
      actionControl: actionControl
    )
  }
  
  
}

