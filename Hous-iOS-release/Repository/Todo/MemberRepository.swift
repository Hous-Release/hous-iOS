//
//  MemberRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import UIKit
import RxSwift
import Network
import Differentiator

public enum MemberRepositoryEvent {
  case members(MemberSection.Model?)
  case selectedMember(MemberTodoModel?)

  case isLoadingHidden(Bool?)

  case sendError(HouseErrorModel?)
}

public protocol MemberRepository {
  var event: PublishSubject<MemberRepositoryEvent> { get }
  func fetchMember(_: Int)
  func selectMember(_: Int)
}

public final class MemberRepositoryImp: BaseService, MemberRepository {
  public var event = PublishSubject<MemberRepositoryEvent>()
  public var todos: [MemberTodoModel]?

  public func fetchMember(_ row: Int) {
    NetworkService.shared.todoRepository.getMemberTodosData { [weak self] res, err in
      guard let self = self else { return }
      guard let data = res?.data else {
        let errorModel = HouseErrorModel(
          success: res?.success ?? false,
          status: res?.status ?? -1,
          message: res?.message ?? "")
        self.event.onNext(.sendError(errorModel))
        return
      }

      let members = self.parseMemberSection(data)
      let memberItems = members.map {
        MemberSection.Item.members(member: $0)
      }
      self.event.onNext(.members(MemberSection.Model(
        model: .members(num: members.count),
        items: memberItems)))

      // MARK: - 구분선
      let todos = self.parseMemberTodo(data)
      self.todos = todos
      let selectedMemTodo = todos[row]
      self.event.onNext(.selectedMember(selectedMemTodo))
      self.event.onNext(.isLoadingHidden(true))
    }
  }

  public func selectMember(_ row: Int) {
    guard let todos = todos else { return }
    let selectedMemTodo = todos[row]
    self.event.onNext(.selectedMember(selectedMemTodo))
  }
}

extension MemberRepositoryImp {
  private func parseMemberSection(_ data: MemberTodoDTO.Response.MemberTodosResponseDTO) -> [MemberDTO] {
    let membersDTO: [MemberDTO] = data.todos.map {
      MemberDTO(
        userName: $0.userName,
        color: $0.color)
    }
    return membersDTO
  }

  private func parseMemberTodoWIthID(_ data: [MemberTodoDTO.Response.DayOfWeekTodo]) -> [DayOfWeekTodoModel] {

    var todoArray: [DayOfWeekTodoModel] = []

    data.forEach { dayOfWeekTodo in

      var infoArray: [TodoInfoWithIdModel] = []

      dayOfWeekTodo.dayOfWeekTodos.forEach { todoInfo in
        let infoDTO = TodoInfoWithIdModel(
          todoId: todoInfo.todoId,
          todoName: todoInfo.todoName)

        infoArray.append(infoDTO)
      }

      let todoDTO = DayOfWeekTodoModel(
        dayOfWeek: dayOfWeekTodo.dayOfWeek,
        dayOfWeekTodos: infoArray)
      todoArray.append(todoDTO)
    }

    return todoArray
  }

  private func parseMemberTodo(
    _ data: MemberTodoDTO.Response.MemberTodosResponseDTO
  ) -> [MemberTodoModel] {

    var memberTodoModel: [MemberTodoModel] = []

    data.todos.forEach { memberTodoDTO in
      var dayOfWeekTodoModel: [DayOfWeekTodoModel] = []

      memberTodoDTO.dayOfWeekTodos.forEach { dayOfWeekTodoDTO in
        var infoModel: [TodoInfoWithIdModel] = []

        dayOfWeekTodoDTO.dayOfWeekTodos.forEach { todoInfoDTO in
          let info = TodoInfoWithIdModel(
            todoId: todoInfoDTO.todoId,
            todoName: todoInfoDTO.todoName)

          infoModel.append(info)
        }

        let dayOfWeekTodo = DayOfWeekTodoModel(
          dayOfWeek: "\(dayOfWeekTodoDTO.dayOfWeek)요일",
          dayOfWeekTodos: infoModel)
        dayOfWeekTodoModel.append(dayOfWeekTodo)
      }

      let memberTodo = MemberTodoModel(
        userName: memberTodoDTO.userName,
        color: HomieFactory.makeHomie(
          type: HomieColor(
            rawValue: memberTodoDTO.color
          ) ?? .GRAY
        ).color,
        totalTodoCnt: memberTodoDTO.totalTodoCnt,
        dayOfWeekTodos: dayOfWeekTodoModel)
      memberTodoModel.append(memberTodo)

    }

    return memberTodoModel
  }
}
