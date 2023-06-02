import UIKit

extension UITextField {
  public func setDatePicker(target: Any, selector: Selector, datePicker: UIDatePicker) {

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

  @objc
  public func tapCancel() {
    self.resignFirstResponder()
  }

  public func addLeftPadding(_ amount: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
}
