//
//  File.swift
//  
//
//  Created by 김호세 on 2022/12/15.
//

import Foundation

class NeedUpdatePopUpAction: PopUpAction {

  let view: NeedUpdatePopUpView
  var completeAction: CompletePopUpAction?

  init(view: NeedUpdatePopUpView) { self.view = view }


  func sendAction() {
    completeAction?(.action)
  }

  func cancel() {
    completeAction?(.cancel)
  }
}
