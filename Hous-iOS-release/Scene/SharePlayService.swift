//
//  SharePlayService.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 3/9/24.
//

import Foundation
import GroupActivities
import RxSwift

final class SharePlayService {

  static let shared = SharePlayService()

  private init() {}

  let codeSubject = PublishSubject<String>()

  private var messenger: GroupSessionMessenger?
  var tasks = Set<Task<Void, Never>>()

  func setSharePlay() {
    Task {
      for await session in ShareCodeActivity.sessions() {
        self.configureGroupSession(session)
      }
    }

  }

  func configureGroupSession(_ session: GroupSession<ShareCodeActivity>) {
    let messenger = GroupSessionMessenger(session: session)
    self.messenger = messenger

    let task = Task.detached {

      // receiving
      for await (code, _) in messenger.messages(of: CodeModel.self) {
        self.codeSubject.onNext(code.code)
      }
    }
    tasks.insert(task)
    session.join()

  }

  func activate() {
    Task {
      do {
        _ = try await ShareCodeActivity().activate()
      } catch {
        print("Failed to activate DrawTogether activity: \(error)")
      }
    }
  }

  func send(code: String) {
    Task {
      try await self.messenger?.send(CodeModel(code: code))
    }
  }
}
