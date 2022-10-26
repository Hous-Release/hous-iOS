//
//  ProfileDetailViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileDetailViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileDetailActionControl>
  }
  
  struct Output {
    let profileDetailModel: Observable<ProfileDetailModel>
    let actionControl: Observable<ProfileDetailActionControl>
  }
  
  
  func transform(input: Input) -> Output {
    
    // Data
    // 서버 연결 후
    // Repository로부터 받아온 profileModel data를 집어넣는다.
    
    // Using Dummy Data
    
    let profileDetailModel = ProfileDetailModel (personalityType: .red)
    
    // end dummy
    
    let profileDetailModelObservable = Observable.just(profileDetailModel)
    
    // Action
    
    let actionControl = input.actionDetected.asObservable()
    
    return Output(
      profileDetailModel: profileDetailModelObservable,
      actionControl: actionControl
    )
  }
  
  
}
