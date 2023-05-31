//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import Foundation
import UIKit

class DefaultBottomSheetAction: BottomSheetAction {

  var view: DefaultBottomSheetView
  var completeAction: CompleteBottomSheetAction?

  init(view: DefaultBottomSheetView) { self.view = view }

  func sendAction(_ action: DidBottomSheetActionType) {
    completeAction?(action)
  }


  func cancel() {
    completeAction?(.cancel)
  }
}
