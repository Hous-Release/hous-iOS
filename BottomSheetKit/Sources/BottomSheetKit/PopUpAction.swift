//
//  File.swift
//  
//
//  Created by 김호세 on 2022/10/26.
//

import Foundation

public typealias CompleteAction = ((DidActionType) -> Void)

protocol PopUpAction {
  func sendAction()
  func cancel()
  var completeAction: CompleteAction? { get }
}
