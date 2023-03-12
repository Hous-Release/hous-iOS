//
//  ByDayRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/10.
//

import Foundation
import Network
import RxSwift
import RxCocoa
import BottomSheetKit

public enum ByDayRepositoryEvent {
  case countTodoSection(MyOurTodoSection.Model)
  case myTodosByDaySection(MyOurTodoSection.Model)
  case myTodosEmptySection(MyOurTodoSection.Model)
  case ourTodosByDaySection(MyOurTodoSection.Model)
  case ourTodosEmptySection(MyOurTodoSection.Model)

  case todoSummary(TodoModel?)

  case isLoadingHidden(Bool?)

  case sendError(HouseErrorModel?)
  case initial
}

public protocol ByDayRepository {
  var event: PublishSubject<ByDayRepositoryEvent> { get }
  func fetchTodo(_: Int)
  func selectDaysOfWeek(_: Int)
  func fetchTodoSummary(_: Int)
}

public final class ByDayRepositoryImp: BaseService, ByDayRepository {
  public var event = PublishSubject<ByDayRepositoryEvent>()
  public var todos: ByDayTodoDTO.Response.ByDayTodosResponseDTO?

  public func fetchTodo(_ row: Int) {

    NetworkService.shared.todoRepository.getDaysOfWeekTodosData { [weak self] res, err in

      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? "")
        self.event.onNext(.sendError(errorModel))
        return
      }

      self.todos = data
      self.onNextEvents(data: data, row: row)
      self.event.onNext(.isLoadingHidden(true))
    }
  }

  public func selectDaysOfWeek(_ row: Int) {
    guard let todos = todos else { return }
    self.event.onNext(.initial)
    onNextEvents(data: todos, row: row)
  }

  // member repository랑 중복됨
  public func fetchTodoSummary(_ id: Int) {
    NetworkService.shared.todoRepository.getTodoSummary(id) { [weak self] res, err in

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

      var homies: [HomieCellModel] = []

      data.selectedUsers.forEach {
        let homie = HomieCellModel(
          homieName: $0.nickname,
          homieColor: HomieFactory.makeHomie(
            type: HomieColor(rawValue: $0.color) ?? .GRAY).color
        )
        homies.append(homie)
      }

      let todoSummary = TodoModel(
        homies: homies,
        todoName: data.name,
        days: data.dayOfWeeks)

      self.event.onNext(.todoSummary(todoSummary))
    }
  }
}

extension ByDayRepositoryImp {
  private func onNextEvents(data: ByDayTodoDTO.Response.ByDayTodosResponseDTO, row: Int) {
    let dataByDay = data.todos[row]

    let countTodoItem = MyOurTodoSection.Item.countTodo(num: dataByDay.ourTodosCnt)
    self.event.onNext(.countTodoSection(MyOurTodoSection.Model(model: .countTodo, items: [countTodoItem])))

    if dataByDay.myTodos.count == 0 {
      self.event.onNext(.myTodosEmptySection(
        MyOurTodoSection.Model(
          model: .myTodoEmpty,
          items: [MyOurTodoSection.Item.myTodoEmpty])))
    } else {
      let myTodoItems = dataByDay.myTodos.map { MyOurTodoSection.Item.myTodo(todos: $0) }
      self.event.onNext(.myTodosByDaySection(
        MyOurTodoSection.Model(
          model: .myTodo(num: dataByDay.myTodos.count),
          items: myTodoItems)
      ))
    }

    if dataByDay.ourTodos.count == 0 {
      self.event.onNext(.ourTodosEmptySection(
        MyOurTodoSection.Model(
          model: .ourTodoEmpty,
          items: [MyOurTodoSection.Item.ourTodoEmpty])))
    } else {
      let ourTodoItems = dataByDay.ourTodos.map { MyOurTodoSection.Item.ourTodo(todos: $0) }
      self.event.onNext(.ourTodosByDaySection(
        MyOurTodoSection.Model(
          model: .ourTodo(num: dataByDay.ourTodos.count),
          items: ourTodoItems)
        ))
    }
  }
}
