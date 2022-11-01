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
  case selectedMember([MemberHeaderItem]?)
  //case sendError(HouseErrorModel?)
}

public protocol MemberRepository {
  var event: PublishSubject<MemberRepositoryEvent> { get }
  func fetchMember()
  func selectMember(_: Int)
}

final class MemberRepositoryImp: BaseService, MemberRepository {
  var event = PublishSubject<MemberRepositoryEvent>()
  var todos: [[MemberHeaderItem]]?

  func fetchMember() {
    guard let data = MockParser.load(MemberTodoDTO.Response.MemberTodosResponseDTO.self, from: "MemberTodoDTO") else { return }

    let members = parseMemberSection(data)
    let memberItems = members.map {
      MemberSection.Item.members(member: $0)
    }
    self.event.onNext(.members(MemberSection.Model(
      model: .members(num: members.count),
      items: memberItems)))

    // MARK: - 구분선

    let todos = data.map { $0.dayOfWeekTodos }
    self.todos = todos
    guard let firstMemTodo = todos.first else { return }
    self.event.onNext(.selectedMember(firstMemTodo))
  }

  func selectMember(_ row: Int) {
    guard let todos = todos else { return }
    let selectedMemTodo = todos[row]
    self.event.onNext(.selectedMember(selectedMemTodo))
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
