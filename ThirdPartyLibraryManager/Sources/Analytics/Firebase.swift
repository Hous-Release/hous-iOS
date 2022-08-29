//
//  File.swift
//  
//
//  Created by 김호세 on 2022/08/28.
//
import Foundation

import FirebaseAnalytics
import FirebaseCore

protocol FirebaseLogEventServicable {
    func configure()
    func logEvent(
        event: AppLogEvent,
        parameter: [String: Any]
    )
}

final class FirebaseLogEventService: FirebaseLogEventServicable {
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

    func logEvent(
        event: AppLogEvent,
        parameter: [String: Any]
    ) {
        Analytics.logEvent(event.rawValue, parameters: parameter)
    }
}

public extension AppLogService {
    class Firebase {
        static var service: FirebaseLogEventServicable = FirebaseLogEventService()

        public static func configure() {
            service.configure()
        }
        public static func logEvent(
            event: AppLogEvent,
            parameter: [String: Any]
        ) {
            service.logEvent(
                event: event,
                parameter: parameter
            )
        }
    }
}

