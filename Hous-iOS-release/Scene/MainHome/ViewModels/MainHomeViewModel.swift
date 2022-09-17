//
//  HousViewModel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/08.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class MainHomeViewModel: ViewModelType {
  
  private let homeUseCase: MainHomeUseCase
  private let disposeBag = DisposeBag()
  
  //MARK: - Input
  struct Input {
    let viewWillAppear: Observable<Void>
    let editButtonDidTapped: Observable<Void>
    let copyCodeButtonDidTapped: Observable<Void>
    let moreMyTodoButtonDidTapped: Observable<Void>
    let moreOurRulesButtonDidTapped: Observable<Void>
    let profileDidTapped: Observable<Void>
  }
  
  //MARK: - Output
  struct Output {
    var titleText = BehaviorRelay<String>(value: "")
    var todoProgress = BehaviorRelay<Int>(value: 0)
    var todoTexts = BehaviorRelay<[String]>(value: [])
    var ourRulesTexts = BehaviorRelay<[String]>(value: [])
    var homies = BehaviorRelay<[HomieModel]>(value: [])
//    let lottie: BehaviorRelay<String>
  }
  
  init(homeUseCase: MainHomeUseCase) {
    self.homeUseCase = homeUseCase
  }
  
  func transform(input: Input) -> Output {
    let output = Output()
    self.bindOutput(output: output)
    
    input.viewWillAppear.subscribe { [weak self] _ in
      
      self?.homeUseCase.getHomeData()
    }
    .disposed(by: disposeBag)
    
    return output
  }
  
  private func bindOutput(output: Output) {
    let nickname = homeUseCase.userNickname
    let roomName = homeUseCase.roomName
    
    let titleText = Observable.combineLatest(nickname, roomName) { nickname, roomName in
      return "\(nickname)님의,\n \(roomName) 하우스"
    }
    
    titleText.subscribe(onNext: { text in
      output.titleText.accept(text)
    })
    .disposed(by: disposeBag)
    
    let progress = homeUseCase.progress
    progress.subscribe(onNext: { progress in
      output.todoProgress.accept(progress)
    })
    .disposed(by: disposeBag)
    
    let todoTexts = homeUseCase.todos
    todoTexts.subscribe { todos in
      output.todoTexts.accept(todos)
    }
    .disposed(by: disposeBag)
    
    let ourRulesTexts = homeUseCase.rules
    ourRulesTexts.subscribe { rules in
      output.ourRulesTexts.accept(rules)
    }
    .disposed(by: disposeBag)
    
    let homies = homeUseCase.homieProfiles
    homies.subscribe { homeModels in
      output.homies.accept(homeModels)
    }
    .disposed(by: disposeBag)
  }
  
}
