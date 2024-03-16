//
//  File.swift
//  
//
//  Created by 김민재 on 2/19/24.
//

import Foundation
import UIKit

final class TodoFilterBottomSheetAction: BottomSheetAction {
  var view: TodoFilterSheetView
  var completeAction: CompleteBottomSheetAction?

  init(view: TodoFilterSheetView) { self.view = view }
}
