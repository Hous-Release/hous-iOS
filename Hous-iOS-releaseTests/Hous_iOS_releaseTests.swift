//
//  Hous_iOS_releaseTests.swift
//  Hous-iOS-releaseTests
//
//  Created by 김호세 on 2023/03/28.
//

import XCTest
@testable import Hous_iOS_release

final class Hous_iOS_releaseTests: XCTestCase {

  var sut: UpdateTodoViewController!

  override func setUpWithError() throws {
    try super.setUpWithError()

    let ho = UpdateTodoHomieModel(
      name: "김호세", color: .BLUE, selectedDay: [], onboardingID: 25, isExpanded: true)

    let reactor = UpdateTodoReactor(provider: ServiceProvider(), state: .init(todoHomies: [ho]))
    sut = UpdateTodoViewController(reactor)
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }


  func testExample() throws {

    let view = sut.view.asImage()

  }

}
