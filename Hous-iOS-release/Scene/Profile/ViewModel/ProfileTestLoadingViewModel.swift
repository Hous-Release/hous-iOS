//
//  ProfileTestLoadingViewModel.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/23.
//


import Foundation
import RxSwift
import RxCocoa

final class ProfileTestLoadingViewModel: ViewModelType {
  
  private let disposeBag: DisposeBag = DisposeBag()
  private let dataLoaded = PublishSubject<PersonalityColor>()
  let timeStart = PublishSubject<Void>()
  let timeFlag = PublishSubject<Bool>()
  private let profileRepository = ProfileRepositoryImp()
  
  struct Input {
    let viewWillAppear: Signal<Void>
  }
  
  struct Output {
    let dataLoaded: PublishSubject<PersonalityColor>
    let timeFlag: PublishSubject<Bool>
  }
  
  init() {
    ProfileRepositoryImp.event
      .subscribe(onNext: { [weak self] event in
        guard let self = self else { return }
        switch event {
        case let .putProfileTestSave(personalityColor):
          self.dataLoaded.onNext(personalityColor)
        case .sendError:
          print("😭 Network Error..😭")
          print(event)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    self.timeStart
      .delay(DispatchTimeInterval.seconds(2), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        self?.timeFlag.onNext(true)
      })
      .disposed(by: disposeBag)
  }
  
  func transform(input: Input) -> Output {
    return Output(
      dataLoaded: dataLoaded, timeFlag: timeFlag
    )
  }
}


