//
//  File.swift
//  
//
//  Created by 김호세 on 2022/10/26.
//

import Foundation

public typealias CompletePopUpAction = ((DidPopUpActionType) -> Void)

protocol PopUpAction {
  func sendAction()
  func cancel()
  var completeAction: CompletePopUpAction? { get }
}
