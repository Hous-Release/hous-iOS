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

  // MARK: - Input
  struct Input {
    let viewWillAppear: Signal<Void>
    let copyButtonDidTapped: PublishRelay<Void>
  }

  // MARK: - Output
  struct Output {
    var sections: Driver<[HomeModel]>
    var roomCode: Driver<String>
  }

  private var sections = BehaviorRelay<[HomeModel]>(value: [])
  private var roomCodeRelay = PublishRelay<String>()
  private var roomCode = ""

  var isYetTested: Bool = false

  func transform(input: Input) -> Output {

    input.viewWillAppear
      .emit { [weak self] _ in
        guard let self = self else { return }
        NetworkService.shared.mainHomeRepository.getHomeData { res, _ in

          guard
            let data = res,
            let model = data.data
          else {
            return
          }

          let myTodoItems = HomeItem.myTodos(todos: model)
          let ourRulesItems = HomeItem.ourTodos(todos: model)

          var user: MainHomeDTO.Response.HomieDTO = .init(color: "", homieID: 0, userNickname: "")
          for homie in model.homies {
            if homie.userNickname == model.userNickname {
              self.isYetTested = homie.color == "GRAY"
              user = homie
              break
            }
          }

          var profileItems: [MainHomeSectionModel.Item] = []
          if self.isYetTested {
            profileItems = [MainHomeSectionModel.Item.homieProfiles(profiles: user)]
          } else {
            profileItems = model.homies.map {
              if model.userNickname == $0.userNickname {
                self.isYetTested = $0.color == "GRAY"
              }
              return HomeItem.homieProfiles(profiles: $0)
            }

          }

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
            items: profileItems
          )

          self.roomCode = model.roomCode
          self.sections.accept([myTodoSectionModel, ourRulesSectionModel, homieProfilesSectionModel])
        }
      }
      .disposed(by: disposeBag)

    input.copyButtonDidTapped
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.roomCodeRelay.accept(self.roomCode)
      })
      .disposed(by: disposeBag)

    return Output(
      sections: sections.asDriver(),
      roomCode: roomCodeRelay.asDriver(onErrorJustReturn: "")
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
