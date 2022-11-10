//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import Foundation

public typealias CompleteBottomSheetAction = ((DidBottomSheetActionType) -> Void)

protocol BottomSheetAction {
  func sendAction()
  func cancel()
  var completeAction: CompleteBottomSheetAction? { get }
}
