//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import XCTest

@testable import Network
@testable import NetworkExtension

class AuthAPITest: XCTestCase {
  var authAPI: AuthAPI!

  override func setUp() {
    super.setUp()
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]

    let configuration2 = URLSessionConfiguration.ephemeral
    authAPI = AuthAPI(configuration: configuration2, isLogging: true)
  }

  override func tearDown() {
    authAPI = nil
    super.tearDown()
  }

  // Hammer, OHTTPS,

  func testAuthAPI() {

    let expectation = XCTestExpectation(description: "response")

    NetworkService.shared.authRepository.login(
      .init(
        fcmToken: "111",
        socialType: "KAKAO",
        token: "ddd"
      )) { res, err in

      if let err = err {
        print(err)
      }

      if let res = res {
          dump(res)
      }
    }

    wait(for: [expectation], timeout: 1)

  }


}



