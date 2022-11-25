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

public enum ByDayRepositoryEvent {
  case countTodoSection(ByDayTodoSection.Model)
  case myTodosByDaySection(ByDayTodoSection.Model)
  case myTodosEmptySection(ByDayTodoSection.Model)
  case ourTodosByDaySection(ByDayTodoSection.Model)
  case ourTodosEmptySection(ByDayTodoSection.Model)
  case sendError(HouseErrorModel?)
  case initial
}

public protocol ByDayRepository {
  var event: PublishSubject<ByDayRepositoryEvent> { get }
  func fetchTodo(_: Int)
  func selectDaysOfWeek(_: Int)
}

public final class ByDayRepositoryImp: BaseService, ByDayRepository {
  public var event = PublishSubject<ByDayRepositoryEvent>()
  public var todos: ByDayTodoDTO.Response.ByDayTodosResponseDTO?

  public func fetchTodo(_ row: Int) {

    NetworkService.shared.byDayTodoRepository.getDaysOfWeekTodosData { [weak self] res, err in

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
    }
  }

  public func selectDaysOfWeek(_ row: Int) {
    guard let todos = todos else { return }
    self.event.onNext(.initial)
    onNextEvents(data: todos, row: row)
  }
}

extension ByDayRepositoryImp {
  private func onNextEvents(data: ByDayTodoDTO.Response.ByDayTodosResponseDTO, row: Int) {
    let dataByDay = data[row]

    let countTodoItem = ByDayTodoSection.Item.countTodo(num: dataByDay.ourTodosCnt)
    self.event.onNext(.countTodoSection(ByDayTodoSection.Model(model: .countTodo, items: [countTodoItem])))

    if dataByDay.myTodos.count == 0 {
      self.event.onNext(.myTodosEmptySection(
        ByDayTodoSection.Model(
          model: .myTodoEmpty,
          items: [ByDayTodoSection.Item.myTodoEmpty])))
    } else {
      let myTodoItems = dataByDay.myTodos.map { ByDayTodoSection.Item.myTodo(todos: $0) }
      self.event.onNext(.myTodosByDaySection(
        ByDayTodoSection.Model(
          model: .myTodo(num: dataByDay.myTodos.count),
          items: myTodoItems)
      ))
    }

    if dataByDay.ourTodos.count == 0 {
      self.event.onNext(.ourTodosEmptySection(
        ByDayTodoSection.Model(
          model: .ourTodoEmpty,
          items: [ByDayTodoSection.Item.ourTodoEmpty])))
    } else {
      let ourTodoItems = dataByDay.ourTodos.map { ByDayTodoSection.Item.ourTodo(todos: $0) }
      self.event.onNext(.ourTodosByDaySection(
        ByDayTodoSection.Model(
          model: .ourTodo(num: dataByDay.ourTodos.count),
          items: ourTodoItems)
        ))
    }
  }
}
