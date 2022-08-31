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
        guard
            let filePath = Bundle.module.path(forResource: "GoogleService-Info", ofType: "plist"),
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

