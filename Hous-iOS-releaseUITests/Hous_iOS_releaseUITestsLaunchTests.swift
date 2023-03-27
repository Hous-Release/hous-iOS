//
//  Hous_iOS_releaseUITestsLaunchTests.swift
//  Hous-iOS-releaseUITests
//
//  Created by 김호세 on 2023/03/27.
//

import XCTest

final class Hous_iOS_releaseUITestsLaunchTests: XCTestCase {

  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
