//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

import Foundation

class EnterRoomPopUpAction: PopUpAction {

  let view: EnterRoomPopUpView
  var completeAction: CompletePopUpAction?

  init(view: EnterRoomPopUpView) { self.view = view }


  func sendAction() {
    completeAction?(.action)
  }

  func cancel() {
    completeAction?(.cancel)
  }
}
