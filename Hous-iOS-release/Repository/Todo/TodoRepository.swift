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
import BottomSheetKit

public enum TodoRepositoryEvent {
  case date(String)
  case dayOfWeek(String)
  case progressType(ProgressType)
  case progress(Float)
  case isTodoEmpty(Bool)
  case myTodosSection(TodoMainSection.Model)
  case myTodosEmptySection(TodoMainSection.Model)
  case ourTodosSection(TodoMainSection.Model)
  case ourTodosEmptySection(TodoMainSection.Model)

  case getAssignees([UpdateTodoHomieModel])
  case getModifyingTodo(UpdateTodoReactor.State)
  case isSuccess(Bool)

  case todoSummary(TodoModel?)
  case isDeleteSuccess(Bool?)

  case isLoadingHidden(Bool?)

  case sendError(HouseErrorModel?)
}

public protocol TodoRepository {
  var event: PublishSubject<TodoRepositoryEvent> { get }
  func fetchTodo()
  func fetchModifyingTodo(_ id: Int)
  func fetchHomie()
  func updateTodo(
    id: Int?,
    isOnPushNotification: Bool,
    name: String,
    _ homies: [UpdateTodoHomieModel]
  )

  func fetchTodoSummary(_: Int)
  func deleteTodo(_: Int)
}

public final class TodoRepositoryImp: BaseService, TodoRepository {
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
      self.event.onNext(.isTodoEmpty(self.zeroTodoFlag(data)))

      if data.myTodosCnt == 0 {
        self.event.onNext(.myTodosEmptySection(
          TodoMainSection.Model(
            model: .myTodoEmpty,
            items: [TodoMainSection.Item.myTodoEmpty])))
      } else {
        let myTodoItems = data.myTodos.map { TodoMainSection.Item.myTodo(todos: $0) }
        self.event.onNext(.myTodosSection(
          TodoMainSection.Model(model: .myTodo(num: data.myTodosCnt), items: myTodoItems)
        ))
      }

      if data.ourTodosCnt == 0 {
        self.event.onNext(.ourTodosEmptySection(
          TodoMainSection.Model(
            model: .ourTodoEmpty,
            items: [TodoMainSection.Item.ourTodoEmpty])))
      } else {
        let ourTodoItems = data.ourTodos.map { TodoMainSection.Item.ourTodo(todos: $0) }
        self.event.onNext(.ourTodosSection(
          TodoMainSection.Model(model: .ourTodo(num: data.ourTodosCnt), items: ourTodoItems)
        ))
      }

      self.event.onNext(.isLoadingHidden(true))
    }
  }

  public func fetchModifyingTodo(_ id: Int) {
    NetworkService.shared.memberTodoRepository.getModifyingTodo(
      todoID: id
    ) { [weak self] res, err in
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

      let homieModels = data.todoUsers.map {
        UpdateTodoHomieModel(
          name: $0.nickname,
          color: HomieColor(rawValue: $0.color) ?? .GRAY,
          selectedDay: $0.dayOfWeeks.map { self.asDay($0) },
          onboardingID: $0.onboardingID,
          isExpanded: $0.dayOfWeeks.isEmpty ? false : true
        )
      }

      let state = UpdateTodoReactor.State(
        isModifying: true,
        isPushNotification: data.isPushNotification,
        todo: data.name,
        todoHomies: homieModels
      )

      self.event.onNext(.getModifyingTodo(state))

    }
  }

  public func fetchHomie() {
    NetworkService.shared.mainTodoRepository.getAssignees { [weak self] res, err in
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
      let homies = data.users.map {
        UpdateTodoHomieModel(
          name: $0.nickname,
          color: HomieColor(rawValue: $0.color) ?? .GRAY,
          selectedDay: [],
          onboardingID: $0.onboardingID,
          isExpanded: false
        )
      }

      self.event.onNext(.getAssignees(homies))
    }
  }
  public func updateTodo(
    id: Int? = nil,
    isOnPushNotification: Bool,
    name: String,
    _ homies: [UpdateTodoHomieModel]
  ) {


    let homiesDTO = homies.map { homie -> TodoUser? in
      guard !homie.selectedDay.isEmpty else { return nil }

      return TodoUser(
        color: homie.color.rawValue,
        dayOfWeeks: homie.selectedDay.map { $0.asDTO },
        isSelected: nil,
        nickname: homie.name,
        onboardingID: homie.onboardingID
      )
    }
      .compactMap { $0 }

    let dto = UpdateTodoDTO.ModifyTodo(
      isPushNotification: isOnPushNotification,
      name: name,
      selectedUsers: nil,
      todoUsers: homiesDTO
    )

    NetworkService.shared.mainTodoRepository.updateTodo(id, dto) { [weak self] res, err in
      guard let self = self else { return }
      guard
        let isSuccess = res?.success,
        isSuccess
      else {
        let errorModel = HouseErrorModel(
          success: res?.success,
          status: res?.status,
          message: res?.message
        )
        self.event.onNext(.isSuccess(false))
        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.isSuccess(true))

    }
  }


  // MARK: - bottomsheet 기능 member & byday
  public func fetchTodoSummary(_ id: Int) {
    NetworkService.shared.mainTodoRepository.getTodoSummary(id) { [weak self] res, err in

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

  public func deleteTodo(_ id: Int) {
    NetworkService.shared.mainTodoRepository.deleteTodo(id) { res, err in
      guard let res = res else { return }

      guard res.success else {
        let errorModel = HouseErrorModel(
          success: res.success,
          status: res.status,
          message: res.message
        )
        self.event.onNext(.sendError(errorModel))
        return
      }

      self.event.onNext(.isDeleteSuccess(true))
      self.event.onNext(.isLoadingHidden(true))
    }
  }
}

extension TodoRepositoryImp {
  private func asDay(_ day: String) -> UpdateTodoHomieModel.Day {
    switch day {
    case "MONDAY":
      return .mon
    case "TUESDAY":
      return .tue
    case "WEDNESDAY":
      return .wed
    case "THURSDAY":
      return .thu
    case "FRIDAY":
      return .fri
    case "SATURDAY":
      return .sat
    case "SUNDAY":
      return .sun

    default:
      return .mon

    }
  }
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

  private func zeroTodoFlag(_ data: MainTodoDTO.Response.MainTodoResponseDTO) -> Bool{
    return (data.myTodosCnt + data.ourTodosCnt == 0) ? true : false
  }
}
