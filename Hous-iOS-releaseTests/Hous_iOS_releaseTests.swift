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

@testable import Hous_iOS_release_module

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

    let vc = UpdateTodoViewController(reactor)

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    scheduler
      .createHotObservable([
        .next(100, .enterTodo("쓰레", isValidate: true)),
        .next(200, .enterTodo("쓰레기", isValidate: true)),
        .next(500, .enterTodo("쓰레기 버리기", isValidate: true)),
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)

    let todoResponse = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {

      reactor.state.map(\.todo)
    }


    XCTAssertEqual(todoResponse.events.compactMap(\.value.element), [
      "",
      "쓰레",
      "쓰레기",
      "쓰레기 버리기",
    ])

    vc.view.asImage()

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

  func testAction_didTapUpdate() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))

    reactor.isStubEnabled = true
    reactor.action.onNext(.didTapUpdate)
    XCTAssertEqual(reactor.stub.actions.last, .didTapUpdate)
  }

  func testAction_updateHomie() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    var new = todoHomies
    new![0].selectedDay = [.sun]

    scheduler
      .createHotObservable([
        .next(100, .updateHomie(new!))
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)


    let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
      reactor.state.map(\.todoHomies[0].selectedDay)
    }

    XCTAssertEqual(response.events.compactMap(\.value.element), [
      [],
      [.sun]
    ])
  }

  func testAction_back() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()


    scheduler
      .createHotObservable([
        .next(100, .back(true))
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)


    let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
      reactor.pulse(\.$isBack)
    }

    XCTAssertEqual(response.events.compactMap(\.value.element), [
      false,
      true
    ])
  }

  func testAction_didTapAlarm() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(id: 0, todoHomies: todoHomies))

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()


    scheduler
      .createHotObservable([
        .next(100, .didTapAlarm)
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)


    let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
      reactor.state.map(\.isPushNotification)
    }

    XCTAssertEqual(response.events.compactMap(\.value.element), [
      true,
      false
    ])
  }

  func test_IsTappableButton() {
    let reactor = UpdateTodoReactor(provider: service, state: .init(todoHomies: todoHomies))

    let vc = UpdateTodoViewController(reactor)

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    todoHomies[0].selectedDay = [.mon, .fri]
    todoHomies[0].isExpanded = true

    scheduler
      .createHotObservable([
        .next(300, .didTapDays([.mon, .fri], id: 0)),
        .next(350, .updateHomie(todoHomies)),
        .next(500, .enterTodo("커피 그만 마시기", isValidate: true)),
        .next(600, .enterTodo("", isValidate: false)),
        .next(1000, .enterTodo("쓰레기 버리기", isValidate: true))
      ])
      .subscribe(reactor.action)
      .disposed(by: disposeBag)


    let response = scheduler.start(created: 0, subscribed: 0, disposed: 1500) {
      reactor.pulse(\.$isTappableButton)
    }

    XCTAssertEqual(response.events.compactMap(\.value.element), [
      false,
      false,
      true,
      false,
      true
    ])

    vc.view.asImage()
  }
}
