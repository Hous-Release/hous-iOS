//
//  File.swift
//  
//
//  Created by 김호세 on 2022/08/28.
//
import Foundation

import FirebaseAnalytics
import FirebaseCore


protocol FirebaseConfiguarable {
  func configure()
}

final class FirebaseConfigure: FirebaseConfiguarable {

  func configure() {

    let filePath: String?

    guard let bundleID = Bundle.main.bundleIdentifier else {
      return
    }

    if bundleID == "com.hous.Hous-iOS-release" {

      filePath = Bundle.module.path(
        forResource: "GoogleService-Info",
        ofType: "plist",
        inDirectory: "/Resource/Production"
      )
    }

    else if bundleID == "com.hous.Hous-iOS-release.staging" {
      filePath = Bundle.module.path(
        forResource: "GoogleService-Info",
        ofType: "plist",
        inDirectory: "/Resource/Staging"
      )
    }

    else {
      filePath = Bundle.module.path(
        forResource: "GoogleService-Info",
        ofType: "plist",
        inDirectory: "/Resource/Development"
      )
    }

    guard
      let filePath = filePath,
      let fileOption = FirebaseOptions(contentsOfFile: filePath)
    else {
      print("Error 발생 GoogleService-Info 파일을 읽을 수 없음.")
      return
    }

    FirebaseApp.configure(options: fileOption)
  }
}

public class FirebaseConfigureService {
  public class Firebase {
    static var service: FirebaseConfiguarable = FirebaseConfigure()
    public static func configure() {
      service.configure()
    }
  }
}

