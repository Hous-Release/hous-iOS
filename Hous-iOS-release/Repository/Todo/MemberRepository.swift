//
//  MemberRepository.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/23.
//

import Foundation
import RxSwift

enum MemberRepositoryEvent {
  case membersSection(MemberTodoSection.Model)
  case todosSection(MemberTodoSection.Model)
  case sendError(HouseErrorModel?)
}

protocol MemberRepository {
  var event: PublishSubject<MemberRepositoryEvent> { get }
  func fetchMember()
}

final class MemberRepositoryImp: MemberRepository {
  var event = PublishSubject<MemberRepositoryEvent>()

  func fetchMember() {
    // Todo: network dto 쓰다가 말았음
    //MockParser.load(MemberTodoDTO.self, from: "TodoMainDTO")
  }
}
