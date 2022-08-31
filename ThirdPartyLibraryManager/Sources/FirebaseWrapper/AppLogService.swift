//
//  File.swift
//  
//
//  Created by 김호세 on 2022/08/28.
//

import Foundation
import FirebaseAnalytics

public class AppLogService { }

protocol FirebaseLogEventServicable {
    func logEvent(
        event: AppLogEvent,
        parameter: [String: Any]
    )
}

final class FirebaseLogEventService: FirebaseLogEventServicable {
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
