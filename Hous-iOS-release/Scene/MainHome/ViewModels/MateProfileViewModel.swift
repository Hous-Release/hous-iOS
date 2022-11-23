//
//  File.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import Foundation
import RxSwift
import RxCocoa

final class MateProfileViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let profileRepository = ProfileRepositoryImp()
  private var profileModel = ProfileModel()
  private let profileModelSubject = PublishSubject<ProfileModel>()
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileActionControl>
  }
  
  struct Output {
    let profileModel: Observable<ProfileModel>
    let actionControl: Observable<ProfileActionControl>
  }
  
  
  init() {
    ProfileRepositoryImp.event
      .debug("repository connected")
      .subscribe (onNext:{ [weak self] event in
      guard let self = self else { return }
      switch event {
      case let .getProfile(profileModel):
        self.profileModel = profileModel
        self.profileModelSubject.onNext(profileModel)
      case .putProfile:
        self.profileRepository.getProfile()
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
    self.profileRepository.getProfile()
    self.profileModelSubject.onNext(self.profileModel)
    
    // Action
    
    let actionControl = input.actionDetected.asObservable()
    
    return Output(
      profileModel: self.profileModelSubject.asObservable(),
      actionControl: actionControl
    )
  }
  
  
}

