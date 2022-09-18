//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/17.
//

import XCTest

@testable import Network
@testable import NetworkExtension

class UserAPITest: XCTestCase {
  var userAPI: UserAPI!

  override func setUp() {
    super.setUp()
    let configuration = URLSessionConfiguration.ephemeral
//    configuration.protocolClasses = [MockURLProtocol.self]
    userAPI = UserAPI(configuration: configuration, isLogging: true)
  }
  override func tearDown() {
    userAPI = nil
    super.tearDown()
  }
  func testCheckExistingUser() {
    let expectation = XCTestExpectation(description: "response")
    userAPI.checkExistingUser(
      checkExistingUserRequestDTO: .init(
        userID: "Devhose1",
        userCI: "134314143434234324",
        phoneNumber: "01077941932"
      )) { (res, err) in
        if let res = res {
          print(res)
        }
        if let err = err {
          print(err)
        }
        expectation.fulfill()
      }
    wait(for: [expectation], timeout: 1)
  }
  func testCheckDuplicateIDAPI() {
    let expectation = XCTestExpectation(description: "response")
    userAPI.checkDuplicateID(checkDuplicateIDRequestDTO: .init(userID: "UserID")) { (res, err) in
      if let res = res {
        print(res)
      }
      if let err = err {
        print(err)
      }
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
  }
}
