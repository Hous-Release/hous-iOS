//
//  KakaoSecretKeyTest.swift
//  Hous-iOS-releaseTests
//
//  Created by 김호세 on 2023/06/27.
//

import Foundation
import XCTest
@testable import Hous_iOS_release_module

final class KakaoSecretKeyTest: XCTestCase {

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func testPrintSecretKEYByConfig() {
    guard let key = Bundle.main.infoDictionary?["KAKAO_AUTH_KEY"] as? String else { return }
    print("KAKAO_AUTH_KEY ==", key)
  }

  func testPrintSecretURLSchemesByConfig() {
    print("KAKAO_URL_SCHEMES ==", Bundle.kakaoURLSchemes)
  }
}

// MARK: For Test extension
fileprivate extension Bundle {

  static let kakaoURLSchemes: String = {

    var result = ""

    guard
      let urlTypes = main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]]
    else {
      return ""
    }
    for urlTypeDictionary in urlTypes {
      guard
        let identifier = urlTypeDictionary["CFBundleURLName"] as? String,
        identifier == "kakaosignin",
        let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [String],
        let kakaoURLScheme = urlSchemes.first

      else {
        continue
      }
      result = kakaoURLScheme
    }
    return result
  }()
}
