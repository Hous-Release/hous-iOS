//
//  ServicesProvider.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/10/08.
//


import Foundation
import Network

public protocol ServiceProviderType: AnyObject {
  var authRepository: AuthRepository { get }
  var enterRoomRepository: EnterRoomRepository { get }
  var memberRepository: MemberRepository { get }
  var byDayRepository: ByDayRepository { get }
//  var userDefaultsService: UserDefaultsServiceType { get }
//  var alertService: AlertServiceType { get }
//  var taskService: TaskServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var authRepository: AuthRepository = AuthRepositoryImp(provider: self)
  lazy var enterRoomRepository: EnterRoomRepository = EnterRoomRepositoryImp(provider: self)
  lazy var memberRepository: MemberRepository = MemberRepositoryImp(provider: self)
  lazy var byDayRepository: ByDayRepository = ByDayRepositoryImp(provider: self)
//  lazy var userDefaultsService: UserDefaultsServiceType = UserDefaultsService(provider: self)
//  lazy var alertService: AlertServiceType = AlertService(provider: self)

}
