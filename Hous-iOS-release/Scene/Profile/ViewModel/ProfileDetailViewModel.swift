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
  private var profileDetailModel = ProfileDetailModel()
  private var profileDetailModelSubject = PublishSubject<ProfileDetailModel>()
  private let profileRepository = ProfileRepositoryImp()
  private var color: PersonalityColor
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileDetailActionControl>
  }
  
  struct Output {
    let profileDetailModel: Observable<ProfileDetailModel>
    let actionControl: Observable<ProfileDetailActionControl>
  }
  
  init(color: PersonalityColor) {
    self.color = color
    ProfileRepositoryImp.event
      .subscribe(onNext: { [weak self] event in
        guard let self = self else { return }
        switch event {
        case let .getProfileTestResult(profileDetailModel):
          self.profileDetailModel = profileDetailModel
          self.profileDetailModelSubject.onNext(profileDetailModel)
        case .sendError:
          print("😭 Network Error..😭")
          print(event)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
  }
  
  
  func transform(input: Input) -> Output {
    
    // Data
    self.profileRepository.getProfileTestResult(color: self.color)
    self.profileDetailModelSubject.onNext(self.profileDetailModel)
    
    let profileDetailModelObservable = profileDetailModelSubject.asObservable()
    
    // Action
    
    let actionControl = input.actionDetected.asObservable()
    
    return Output(
      profileDetailModel: profileDetailModelObservable,
      actionControl: actionControl
    )
  }
  
  
}
