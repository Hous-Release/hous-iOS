//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/01.
//

import Foundation
import FirebaseMessaging

protocol FirebaseMessagingServicable {
    func configure()
    func registerDeviceToken(deviceToken: Data)
    func setAPNSToken(deviceToken: Data)
    func deleteToken()
    func printFCMToken()
}

public class MessagingService: NSObject { }

final class FirebaseMessagingService: NSObject { }

extension FirebaseMessagingService: FirebaseMessagingServicable {

    func configure() {
        Messaging.messaging().delegate = self
    }

    func registerDeviceToken(deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func setAPNSToken(deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    func deleteToken() {
        Messaging.messaging().deleteToken { err in
            print(err!)
        }
    }
    func printFCMToken() {
        Messaging.messaging().token { token, err in
            print(token!)
        }
    }
}
public extension MessagingService {
    class Firebase {
        static var service: FirebaseMessagingServicable = FirebaseMessagingService()
        public static func configure() {
            service.configure()
        }
        public static func registerDeviceToken(deviceToken: Data) {
            service.registerDeviceToken(deviceToken: deviceToken)
        }
        public static func setAPNSToken(deviceToken: Data) {
            service.setAPNSToken(deviceToken: deviceToken)
        }
        public static func deleteToken() {
            service.deleteToken()
        }
        public static func printFCMToken() {
            service.printFCMToken()
        }
    }
}
extension FirebaseMessagingService: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            return
        }
        print("fcmToken in a module: ", fcmToken)
    }
}
