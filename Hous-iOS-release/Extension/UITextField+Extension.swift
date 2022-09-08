//
//  UITextField+Extension.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

extension UITextField {
  func setDatePicker(target: Any, selector: Selector, datePicker: UIDatePicker) {

      datePicker.datePickerMode = .date
      datePicker.preferredDatePickerStyle = .wheels
      self.inputView = datePicker

      let toolBar = UIToolbar()
      toolBar.sizeToFit()
      let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
      let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
      toolBar.setItems([cancel, flexible, barButton], animated: false)
      self.inputAccessoryView = toolBar
  }

  @objc func tapCancel() {
      self.resignFirstResponder()
  }
}
