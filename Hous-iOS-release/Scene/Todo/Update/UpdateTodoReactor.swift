//
//  UpdateReactork.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import Foundation
import ReactorKit

final class UpdateTodoReactor: Reactor {
  private let provider: ServiceProvider
  internal let initialState: State

  init(
    provider: ServiceProvider,
    state: State
  ) {
    self.initialState = state
    self.provider = provider
  }


  enum Action {

  }

  enum Mutation {

  }

  struct State {

  }

}
