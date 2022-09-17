//
//  MainHomeUseCase.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/10.
//

import Foundation
import RxRelay
import RxSwift

protocol MainHomeUseCase {
  func getHomeData()
  
  var userNickname: PublishRelay<String> { get set }
  var roomName: PublishRelay<String> { get set }
  var progress: PublishRelay<Int> { get set }
  var todos: PublishRelay<[String]> { get set }
  var rules: PublishRelay<[String]> { get set }
  var homieProfiles: PublishRelay<[HomieModel]> { get set }
  var homeScrollToTop: PublishRelay<Void> { get set }
}

final class DefaultMainHomeUseCase: MainHomeUseCase {
  
  private let homeRepository: MainHomeRepository
  private let disposeBag = DisposeBag()
  
  var userNickname = PublishRelay<String>()
  var roomName = PublishRelay<String>()
  var progress = PublishRelay<Int>()
  var todos = PublishRelay<[String]>()
  var rules = PublishRelay<[String]>()
  var homieProfiles = PublishRelay<[HomieModel]>()
  var homeScrollToTop = PublishRelay<Void>()
  
  init(homeRepository: MainHomeRepository) {
    self.homeRepository = homeRepository
  }
  
  func getHomeData() {
    homeRepository.getHomeData()
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] dto in
        guard let self = self else { return }
        let model = dto!.toDomain()
        self.userNickname.accept(model.userNickname)
        self.roomName.accept(model.roomName)
        self.progress.accept(model.progress)
        self.todos.accept(model.myTodos)
        self.rules.accept(model.ourRules)
        self.homieProfiles.accept(model.homies)
      })
      .disposed(by: disposeBag)
  }
  
}
