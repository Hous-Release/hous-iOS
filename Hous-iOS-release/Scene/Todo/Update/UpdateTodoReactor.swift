//
//  UpdateReactork.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import Foundation
import ReactorKit
import Network

public final class UpdateTodoReactor: Reactor {
  private let provider: ServiceProvider
  public let initialState: State
  public var fetchedInitalTodo: String?

  public init(
    provider: ServiceProvider,
    state: State
  ) {
    self.initialState = state
    self.provider = provider
  }

  public enum Action {
    case fetch
    case enterTodo(String?)
    case didTapHomie(IndexPath)
    case didTapDays([UpdateTodoHomieModel.Day], id: Int)
    case didTapUpdate
    case updateHomie([UpdateTodoHomieModel])
    case back(Bool)
    case didTapAlarm
  }

  public enum Mutation {
    case setNotification(Bool)
    case setTodo(String?)
    case setHomies([UpdateTodoHomieModel])
    case setIndividual(IndexPath)
    case setDay([UpdateTodoHomieModel.Day], Int)
    case setBack(Bool)
    case sendError(HouseErrorModel?)
  }

  public struct State {
    var id: Int?
    var isModifying: Bool = false
    var isPushNotification: Bool = true
    var todo: String?
    var todoHomies: [UpdateTodoHomieModel]
    @Pulse
    var didTappedIndividual: IndexPath?
    @Pulse
    var didTappedDay: ([UpdateTodoHomieModel.Day], Int)?
    @Pulse
    var isBack: Bool = false
    @Pulse
    var errorModel: HouseErrorModel?
    @Pulse
    var isTappableButton: Bool = false
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetch:
      if initialState.isModifying {
        provider.todoRepository.fetchModifyingTodo(initialState.id ?? -1)
      } else {
        return Observable.concat([
          .just(.setTodo(initialState.todo)),
          .just(.setHomies(initialState.todoHomies))
        ])
      }

      return .empty()

    case .enterTodo(let string):
      return .just(.setTodo(string))
    case .didTapHomie(let indexPath):
      return .just(.setIndividual(indexPath))
    case .didTapDays(let days, let id):
      return .just(.setDay(days, id))
    case .didTapUpdate:

      provider.todoRepository.updateTodo(
        id: currentState.id,
        isOnPushNotification: currentState.isPushNotification,
        name: currentState.todo ?? "",
        currentState.todoHomies
      )
      return .empty()
    case .updateHomie(let homies):
      return .just(.setHomies(homies))

    case .back(let backFlag):
      return .just(.setBack(backFlag))

    case .didTapAlarm:
      return .just(.setNotification(!currentState.isPushNotification))
    }
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setNotification(let notification):
      newState.isPushNotification = notification

    case .setTodo(let todo):
      newState.todo = todo
      var isSelectedDays = false
      for homie in currentState.todoHomies where !homie.selectedDay.isEmpty {
//        if !homie.selectedDay.isEmpty {
          isSelectedDays = true
          break
//        }

      }
      newState.isTappableButton = (isSelectedDays && todo != "" && todo != nil)

    case .setHomies(let homies):
      newState.todoHomies = homies
      var isSelectedDays = false
      for homie in homies where !homie.selectedDay.isEmpty {
//        if !homie.selectedDay.isEmpty {
          isSelectedDays = true
          break
//        }
      }
      newState.isTappableButton = (isSelectedDays
                                   && currentState.todo != ""
                                   && currentState.todo != nil)

    case .setIndividual(let indexPath):
      newState.didTappedIndividual = indexPath
    case .setDay(let days, let id):
      newState.didTappedDay = (days, id)
    case .setBack(let backFlag):
      newState.isBack = backFlag
    case .sendError(let errorMessage):
      newState.errorModel = errorMessage
    }
    return newState
  }
}

public extension UpdateTodoReactor {

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let service =
      provider.todoRepository.event.flatMap { event -> Observable<Mutation> in

      switch event {
      case .getModifyingTodo(let state):

        self.fetchedInitalTodo = state.todo

        return Observable.concat([
          .just(.setNotification(state.isPushNotification)),
          .just(.setTodo(state.todo)),
          .just(.setHomies(state.todoHomies))
        ])

      case .isSuccess(let isSuccess):
        return .just(.setBack(isSuccess))
      case .sendError(let sendError):

        return .just(.sendError(sendError))

      default:
        return .empty()
      }
    }
    return Observable.merge(mutation, service)
  }
}
