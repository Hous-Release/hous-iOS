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
import Network

typealias HomeModel = MainHomeSectionModel.Model
typealias HomeItem = MainHomeSectionModel.Item

final class MainHomeViewModel: ViewModelType {
  
  private let disposeBag = DisposeBag()
  
  //MARK: - Input
  struct Input {
    let viewWillAppear: Signal<Void>
  }
  
  //MARK: - Output
  struct Output {
    var sections: Driver<[HomeModel]>
  }
    
  private var sections = BehaviorRelay<[HomeModel]>(value: [])
    
  func transform(input: Input) -> Output {
    
    input.viewWillAppear
      .emit { [weak self] _ in
        guard let self = self else { return }
        NetworkService.shared.mainHomeRepository.getHomeData { res, error in

          guard
            let data = res,
            let model = data.data
          else {
            return
          }
                    
          let myTodoItems = HomeItem.myTodos(todos: model)
          let ourRulesItems = HomeItem.ourTodos(todos: model)
          let profileItems = HomeItem.homieProfiles(profiles: model.homies)

          let myTodoSectionModel = HomeModel(
            model: .myTodos,
            items: [myTodoItems]
          )
          
          let ourRulesSectionModel = HomeModel(
            model: .ourTodos,
            items: [ourRulesItems]
          )
          
          let homieProfilesSectionModel = HomeModel(
            model: .homieProfiles,
            items: [profileItems]
          )
          
          self.sections.accept([myTodoSectionModel, ourRulesSectionModel, homieProfilesSectionModel])
        }
      }
      .disposed(by: disposeBag)
    
    return Output(
      sections: sections.asDriver()
    )
  }
  
    
  //  func toDomain() -> MainHomeModel {
  //
  //    let homieList = self.homies.map({ dto in
  //      return HomieModel(
  //        color: dto.color,
  //        userNickname: dto.userNickname)
  //    })
  //
  //    return MainHomeModel(
  //      userNickname: self.userNickname,
  //      roomName: self.roomName,
  //      progress: self.progress,
  //      myTodos: self.myTodos,
  //      ourRules: self.ourRules,
  //      homies: homieList
  //    )
  //  }
}
