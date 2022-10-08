//
//  TodoRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/13.
//

import Foundation
import Network
import RxSwift
import RxCocoa

public enum TodoRepositoryEvent {
  case date(String)
  case dayOfWeek(String)
  case progressType(ProgressType)
  case progress(Float)
  case myTodosSection(TodoMainSection.Model)
  case ourTodosSection(TodoMainSection.Model)
  case sendError(HouseErrorModel?)
}

public protocol TodoRepository {
  var event: PublishSubject<TodoRepositoryEvent> { get }
  func fetchTodo()
}

public final class TodoRepositoryImp: TodoRepository {
  public var event = PublishSubject<TodoRepositoryEvent>()

  public func fetchTodo() {
    NetworkService.shared.mainTodoRepository.getTodosData { [weak self] res, err in
      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? "")
        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.date(data.date))
      self.event.onNext(.dayOfWeek(self.parse(of: data.dayOfWeek)))
      self.event.onNext(.progressType(self.getType(of: data.progress)))
      self.event.onNext(.progress(Float(data.progress)))

      let myTodoItems = data.myTodos.map { TodoMainSection.Item.myTodo(todos: $0) }
      self.event.onNext(.myTodosSection(
        TodoMainSection.Model(model: .myTodo(num: data.myTodosCnt), items: myTodoItems)
      ))

      let ourTodoItems = data.ourTodos.map { TodoMainSection.Item.ourTodo(todos: $0) }
      self.event.onNext(.ourTodosSection(
        TodoMainSection.Model(model: .ourTodo(num: data.ourTodosCnt), items: ourTodoItems)
      ))
    }
  }


}

extension TodoRepositoryImp {
  private func parse(of dayOfWeek: String) -> String {
    return dayOfWeek.prefix(1) + dayOfWeek.dropFirst().lowercased()
  }

  private func getType(of progress: Int) -> ProgressType {
    if progress == 0 {
      return .none
    } else if progress > 0 && progress < 50 {
      return .underHalf
    } else if progress >= 50 && progress < 100 {
      return .overHalf
    } else {
      return .done
    }
  }
}