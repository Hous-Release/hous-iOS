//
//  Hous_iOS_releaseTests.swift
//  Hous-iOS-releaseTests
//
//  Created by 김호세 on 2023/03/28.
//

import Foundation
import ReactorKit
import RxTest
import RxBlocking
import XCTest

@testable import Hous_iOS_release
import UserInformation

final class Hous_iOS_releaseTests: XCTestCase {

  var todoHomies: [UpdateTodoHomieModel]!
  var service: ServiceProvider!

  override func setUpWithError() throws {
    try super.setUpWithError()

    service = ServiceProvider()
    todoHomies = []

    for i in 0 ..< 7 {
      let updateTodoHomieModel = UpdateTodoHomieModel(
        name: "김호세\(i)",
        color: .BLUE,
        selectedDay: [],
        onboardingID: i,
        isExpanded: false
      )

      todoHomies.append(updateTodoHomieModel)

    }
  }


  override func tearDownWithError() throws {
    todoHomies = nil
    service = nil
    try super.tearDownWithError()
  }


  func testAction_fetch() {

    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))
    reactor.action.onNext(.fetch)

    XCTAssertEqual(reactor.currentState.todoHomies.count, 7)
    XCTAssertEqual(reactor.currentState.didTappedIndividual, nil)
    XCTAssertEqual(reactor.currentState.isModifying, false)
    XCTAssertEqual(reactor.currentState.isPushNotification, true)
    XCTAssertEqual(reactor.currentState.todoHomies[0].name, "김호세0")
  }

  func testAction_enterTodo() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    scheduler
      .createHotObservable([
        .next(100, .enterTodo("쓰레")),
        .next(200, .enterTodo("쓰레기")),
        .next(500, .enterTodo("쓰레기 버리기")),
        .next(700, .enterTodo(""))
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)

    let todoResponse = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {

      reactor.state.map(\.todo)
    }


    XCTAssertEqual(todoResponse.events.compactMap(\.value.element), [
      nil,
      "쓰레",
      "쓰레기",
      "쓰레기 버리기",
      ""
    ])

  }

  func testAction_didTapHomie() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    scheduler
      .createHotObservable([
        .next(100, .didTapHomie(IndexPath(item: 0, section: 0))),
        .next(200, .didTapHomie(IndexPath(item: 0, section: 1)))
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)


    let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
      reactor.state.map(\.didTappedIndividual)
    }


    XCTAssertEqual(response.events.compactMap(\.value.element), [
      nil,
      IndexPath(item: 0, section: 0),
      IndexPath(item: 0, section: 1)
    ])

  }

  // MARK: - Tuple은 Equtable이 구현될 수 없어서 - 값을 같이 테스트할 수가 없음
  // -
  func testAction_didTapDay() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    scheduler
      .createHotObservable([
        .next(100, .didTapDays([.mon, .sun], id: 9)),
        .next(500, .didTapDays([.wed, .sat], id: 9))
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)


    let daysResponse = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
      reactor.state.map(\.didTappedDay?.0)
    }
    XCTAssertEqual(daysResponse.events.compactMap(\.value.element), [
      nil,
      [UpdateTodoHomieModel.Day.mon, UpdateTodoHomieModel.Day.sun],
      [UpdateTodoHomieModel.Day.wed, UpdateTodoHomieModel.Day.sat],
    ])

  }
}
