//
//  MemberCollectionViewCellReactor.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/27.
//

import Foundation
import ReactorKit

public class MemberCollectionViewCellReactor: ReactorKit.Reactor {

  public let initialState: MemberDTO

  public enum Action {
    case didTapButton
  }

  public enum Mutation {
    case setTappedMember
  }

  init(state: MemberDTO) {
    self.initialState = state
  }

}
