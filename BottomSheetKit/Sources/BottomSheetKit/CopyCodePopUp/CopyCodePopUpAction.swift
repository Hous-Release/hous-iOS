//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

class CopyCodePopUpAction: PopUpAction {

  let view: CopyCodePopUpView
  var completeAction: CompletePopUpAction?

  init(view: CopyCodePopUpView) { self.view = view }


  func sendAction() {
    completeAction?(.action)
  }

  func cancel() {
    completeAction?(.cancel)
  }
}
