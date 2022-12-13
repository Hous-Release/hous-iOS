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
  var todoRepository: TodoRepository { get }
  var profileLeaveRepository: ProfileLeaveRepository { get }
  var userRepository: UserRepository { get }
}

public final class ServiceProvider: ServiceProviderType {

  public lazy var authRepository: AuthRepository = AuthRepositoryImp(provider: self)
  public lazy var enterRoomRepository: EnterRoomRepository = EnterRoomRepositoryImp(provider: self)
  public lazy var memberRepository: MemberRepository = MemberRepositoryImp(provider: self)
  public lazy var byDayRepository: ByDayRepository = ByDayRepositoryImp(provider: self)
  public lazy var todoRepository: TodoRepository = TodoRepositoryImp(provider: self)
  public lazy var profileLeaveRepository: ProfileLeaveRepository = ProfileLeaveRepositoryImp(provider: self)
  public lazy var userRepository: UserRepository = UserRepositoryImp(provider: self)

}
