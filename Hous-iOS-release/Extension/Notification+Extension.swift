//
//  Notification+Extension.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/10.
//

import Foundation

extension NSNotification.Name {
  static let change = Notification.Name("UITextFieldTextDidChangeNotification")
  static let beginEdit = Notification.Name("UITextFieldTextDidBeginEditingNotification")
  static let endEdit = Notification.Name("UITextFieldTextDidEndEditingNotification")
}
