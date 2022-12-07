//
//  ResignInputCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit

protocol ResignInputCellDelegate {
  func didTapTextField()
  func didTapTextView()
}

class ResignInputCollectionViewCell: UICollectionViewCell {

  var delegate: ResignInputCellDelegate?

  let reasonArray: [String] = [
    "사유 선택하기",
    "공동생활이 끝나서",
    "이용이 불편하고 장애가 많아서",
    "사용 빈도가 낮아서"
  ]

  enum Size {
    static let textfieldHeight = 36
    static let resignButtonHeight = 44
    static let resignCheckButtonHeight = 24
  }

  let titleLabel = UILabel().then {
    $0.text = "피드백 남기기"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }

  let reasonTextField = GrayBackgroundTextField()

  let reasonPickerView = UIPickerView()

  let reasonTextView = UnderlinedTextFieldStackView()

  let resignCheckButton = UIButton(configuration: .plain()).then {

    var attrString = AttributedString("탈퇴하겠습니다.")
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    attrString.foregroundColor = Colors.g5.color
    $0.configuration?.attributedTitle = attrString
    $0.configuration?.baseBackgroundColor = Colors.white.color
    $0.configuration?.imagePlacement = .leading
    $0.configuration?.imagePadding = 8
    $0.configurationUpdateHandler = { btn in
      switch btn.state {
      case .normal:
        btn.configuration?.image = Images.icCheckNotOnboardSetting.image
      case .selected:
        btn.configuration?.image = Images.icCheckYesOnboardSetting.image
      default:
        break
      }
    }
  }

  let resignButton = UIButton(configuration: .filled()).then {

    var attrString = AttributedString("방 퇴사하기")
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    attrString.foregroundColor = Colors.white.color
    $0.configuration?.attributedTitle = attrString
    $0.configuration?.baseBackgroundColor = Colors.red.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ResignInputCollectionViewCell {

  private func render() {
    addSubViews([titleLabel, reasonTextField, reasonTextView, resignCheckButton, resignButton])

    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.top.equalToSuperview().offset(18)
    }

    reasonTextField.snp.makeConstraints { make in
      make.trailing.leading.equalToSuperview().inset(24)
      make.top.equalTo(titleLabel.snp.bottom).offset(18)
      make.height.equalTo(Size.textfieldHeight)
    }

    reasonTextView.snp.makeConstraints { make in
      make.top.equalTo(reasonTextField.snp.bottom).offset(18)
      make.trailing.leading.equalToSuperview().inset(24)
    }

    resignCheckButton.snp.makeConstraints { make in
      make.height.equalTo(Size.resignCheckButtonHeight)
      make.centerX.equalToSuperview()
      make.top.equalTo(reasonTextView.snp.bottom).offset(44)
    }

    resignButton.snp.makeConstraints { make in
      make.trailing.leading.equalToSuperview().inset(24)
      make.top.equalTo(resignCheckButton.snp.bottom).offset(16)
      make.height.equalTo(Size.resignButtonHeight)
      make.bottom.equalToSuperview().inset(40)
    }
  }

  private func setup() {

    reasonTextView.textView.delegate = self
    reasonTextField.addTarget(self, action: #selector(tapTextField), for: .editingDidBegin)

    reasonTextField.inputView = reasonPickerView
    reasonPickerView.delegate = self
    reasonPickerView.dataSource = self

    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
    let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(tapDone))
    toolBar.setItems([cancel, flexible, barButton], animated: false)
    reasonTextField.inputAccessoryView = toolBar
  }

  @objc func tapDone() {
      self.endEditing(true)
  }
  @objc func tapCancel() {
      self.resignFirstResponder()
  }
  @objc func tapTextField() {
    self.delegate?.didTapTextField()
  }
}

extension ResignInputCollectionViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return reasonArray.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return reasonArray[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    reasonTextField.text = reasonArray[row]
  }
}

extension ResignInputCollectionViewCell: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    delegate?.didTapTextView()
  }
}
