//
//  File.swift
//  
//
//  Created by 김호세 on 2023/06/02.
//

import Foundation

internal extension NSNotification.Name {
  static let change = Notification.Name("UITextFieldTextDidChangeNotification")
  static let beginEdit = Notification.Name("UITextFieldTextDidBeginEditingNotification")
  static let endEdit = Notification.Name("UITextFieldTextDidEndEditingNotification")
}
