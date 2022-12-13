//
//  ProfileLeaveRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/14.
//

import Foundation
import Network
import RxSwift

public enum ProfileLeaveRepositoryEvent {
  case guideSection(OnlyMyTodoSection.Model)
  case countTodoSection(OnlyMyTodoSection.Model)
  case myTodosByDaySection(OnlyMyTodoSection.Model)
  case myTodosEmptySection(OnlyMyTodoSection.Model)

  case sendError(HouseErrorModel?)
}

public protocol ProfileLeaveRepository {
  var event: PublishSubject<ProfileLeaveRepositoryEvent> { get }
  func fetchOnlyMyTodo()
}

public final class ProfileLeaveRepositoryImp: BaseService, ProfileLeaveRepository {
  public var event = PublishSubject<ProfileLeaveRepositoryEvent>()

  public func fetchOnlyMyTodo() {
    NetworkService.shared.byDayTodoRepository.getOnlyMyTodoData { [weak self] res, err in

      guard let self = self else { return }

      guard let data = res?.data else {

        let errorModel = HouseErrorModel(
          success: res?.success,
          status: res?.status,
          message: res?.message
        )
        self.event.onNext(.sendError(errorModel))
        return
      }

      self.onNextEvents(data: data)
    }
  }

}

extension ProfileLeaveRepositoryImp {
  private func onNextEvents(data: ByDayTodoDTO.Response.OnlyMyTodoDTO) {

    let guideItem = OnlyMyTodoSection.Item.guide
    self.event.onNext(.guideSection(OnlyMyTodoSection.Model(
      model: .guide,
      items: [guideItem])))

    let countTodoItem = OnlyMyTodoSection.Item.countTodo(num: data.myTodosCnt)
    self.event.onNext(.countTodoSection(OnlyMyTodoSection.Model(
      model: .countTodo,
      items: [countTodoItem])))

    if data.myTodos.count == 0 {
      self.event.onNext(.myTodosEmptySection(
        OnlyMyTodoSection.Model(
          model: .myTodoEmpty,
          items: [OnlyMyTodoSection.Item.myTodoEmpty])))
      print("아니 왜 슈발 안되는건데 안되는건데 안되는건데 안되는건데 안되는건데 안되는건데")
    } else {
      let myTodoItems = data.myTodos.map { OnlyMyTodoSection.Item.myTodo(todos: $0) }
      self.event.onNext(.myTodosByDaySection(
        OnlyMyTodoSection.Model(
          model: .myTodo(num: data.myTodos.count),
          items: myTodoItems)
      ))
    }

  }
}
