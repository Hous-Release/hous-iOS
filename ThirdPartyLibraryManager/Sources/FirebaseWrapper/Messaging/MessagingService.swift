//
//  File.swift
//  
//
//  Created by 김호세 on 2022/09/01.
//

import Foundation
import FirebaseMessaging


public typealias ResultFCMToken = ((String?,Error?) -> Void)
protocol FirebaseMessagingServicable {

    func configure()
    func registerDeviceToken(deviceToken: Data)
    func setAPNSToken(deviceToken: Data)
    func deleteToken()
    func getFCMToken(completion: @escaping ResultFCMToken)
}

public class MessagingService: NSObject {

    public var tokenHandler: ((String) -> Void)?
}

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
    func getFCMToken(completion: @escaping ResultFCMToken) {
        Messaging.messaging().token { token, err in

            guard let token = token else {
                completion(nil, err)
                return
            }

            completion(token, err)
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
        public static func getFCMToken(completion: @escaping ResultFCMToken) {
            service.getFCMToken(completion: completion)
        }
    }
}
extension FirebaseMessagingService: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            return
        }
    }
}
