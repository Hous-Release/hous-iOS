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
}
