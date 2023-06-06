//
//  File.swift
//  
//
//  Created by 김호세 on 2022/11/10.
//

import Foundation
import UIKit

class TodoBottomSheetAction: BottomSheetAction {
  var view: TodoBottomSheetView
  var completeAction: CompleteBottomSheetAction?

  init(view: TodoBottomSheetView) { self.view = view }
}
