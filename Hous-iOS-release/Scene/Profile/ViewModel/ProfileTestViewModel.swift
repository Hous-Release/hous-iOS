//
//  ProfileTestViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/15.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileTestInfoViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  struct Input {
    let viewWillAppear: Signal<Void>
    let actionDetected: PublishSubject<ProfileTestInfoActionControl>
  }
  
  struct Output {
    let actionControl: Observable<ProfileTestInfoActionControl>
  }
  
  
  func transform(input: Input) -> Output {

    // Action
    
    let actionControl = input.actionDetected.asObservable()
    
    return Output(
      actionControl: actionControl
    )
  }
  
  
}

