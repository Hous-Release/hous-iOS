//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/01.
//

class CopyCodePopUpAction: PopUpAction {

  let view: CopyCodePopUpView
  var completeAction: CompleteAction?

  init(view: CopyCodePopUpView) { self.view = view }


  func sendAction() {
    completeAction?(.action)
  }

  func cancel() {
    completeAction?(.cancel)
  }
}
