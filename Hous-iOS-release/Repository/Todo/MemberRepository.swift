//
//  MemberRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation
import RxSwift
import Network
import Differentiator

public enum MemberRepositoryEvent {
  case membersSection(MemberSection.Model?)
  //case todosSection(TodoByMemSection.Model?)
  //case sendError(HouseErrorModel?)
}

public protocol MemberRepository {
  var event: PublishSubject<MemberRepositoryEvent> { get }
  func fetchMember()
}

final class MemberRepositoryImp: BaseService, MemberRepository {
  var event = PublishSubject<MemberRepositoryEvent>()

  func fetchMember() {
    guard let data = MockParser.load(MemberTodoDTO.Response.MemberTodosResponseDTO.self, from: "MemberTodoDTO") else { return }

    let members = parseMemberSection(data)
    let memberItems = members.map {
      MemberSection.Item.members(member: $0)
    }
    self.event.onNext(.membersSection(MemberSection.Model(
      model: .members(num: members.count),
      items: memberItems)))


//    let todos = data.map { $0.dayOfWeekTodos }
//    guard let firstMemTodo = todos.first else { return }
//    let firstMemTodoItems = firstMemTodo.map {
//      TodoByMemSection.Item.todos(todo: $0)
//    }
//    self.event.onNext(.todosSection(TodoByMemSection.Model(
//      model: .todos(num: todos.count),
//      items: firstMemTodoItems)))
  }
}

extension MemberRepositoryImp {
  private func parseMemberSection(_ data: MemberTodoDTO.Response.MemberTodosResponseDTO) -> [MemberDTO] {
    let membersDTO: [MemberDTO] = data.map {
      MemberDTO(
        userName: $0.userName,
        color: $0.color)
    }
    return membersDTO
  }
}
