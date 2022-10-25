//
//  MemberRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation
import RxSwift
import Network

enum MemberRepositoryEvent {
  case membersSection(MemberTodoSection.Model?)
  case todosSection(MemberTodoSection.Model?)
  //case sendError(HouseErrorModel?)
}

protocol MemberRepository {
  var event: PublishSubject<MemberRepositoryEvent> { get }
  func fetchMember()
}

final class MemberRepositoryImp: MemberRepository {
  var event = PublishSubject<MemberRepositoryEvent>()

  func fetchMember() {
    guard let data = MockParser.load(MemberTodoDTO.Response.MemberTodosResponseDTO.self, from: "MainTodoResponseDTO") else { return }

    let members = parseMemberSection(data)
    let memberItems = members.map {
      MemberTodoSection.Item.members(member: $0)
    }

    let todos = data.map { $0.dayOfWeekTodos }
    guard let firstMemTodo = todos.first else { return }
    let firstMemTodoItems = firstMemTodo.map {
      MemberTodoSection.Item.todos(todo: $0)
    }

    self.event.onNext(.membersSection(MemberTodoSection.Model(
      model: .members(num: data.count),
      items: memberItems)))

    self.event.onNext(.todosSection(MemberTodoSection.Model(
      model: .todos(num: todos.count),
      items: firstMemTodoItems)))
  }
}

extension MemberRepositoryImp {
  private func parseMemberSection(_ data: MemberTodoDTO.Response.MemberTodosResponseDTO) -> [MemberDTO] {
    let membersDTO: [MemberDTO] = data.map {
      MemberDTO(
        userName: $0.userName,
        color: $0.color,
        totalTodoCnt: $0.totalTodoCnt)
    }
    return membersDTO
  }
}
