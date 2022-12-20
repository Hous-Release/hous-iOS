//
//  ResignInputCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit

protocol ResignInputCellDelegate {
  func didTextViewChange(_ estimatedSize: CGSize, _ height: CGFloat)
}

class ResignInputCollectionViewCell: UICollectionViewCell {

  var delegate: ResignInputCellDelegate?

  let reasonArray: [ResignReasonType] = [
    ResignReasonType.no,
    ResignReasonType.doneLivingTogether,
    ResignReasonType.inconvenientToUse,
    ResignReasonType.lowUsage,
    ResignReasonType.contentsUnsatisfactory,
    ResignReasonType.etc
  ]

  enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let textfieldHeight = 36
    static let resignButtonHeight = 44
    static let resignCheckButtonHeight = 24
  }

  let mainView = UIView()

  let titleLabel = UILabel().then {
    $0.text = "피드백 남기기"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }

  let reasonTextField = GrayBackgroundTextField()

  let reasonPickerView = UIPickerView()

  let reasonTextView = UnderlinedTextStackView(
    placeholder: "의견 남기기",
    isTextViewEmpty: true,
    maxStringNum: 200
  )

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

    var attrString = AttributedString("회원 탈퇴하기")
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    attrString.foregroundColor = Colors.white.color
    $0.configuration?.attributedTitle = attrString

    $0.configurationUpdateHandler = { btn in
      switch btn.state {
      case .disabled:
        btn.configuration?.baseBackgroundColor = Colors.g5.color
      case .normal:
        btn.configuration?.baseBackgroundColor = Colors.red.color
      default:
        break
      }
    }
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
    addSubView(mainView)
    mainView.addSubViews([titleLabel, reasonTextField, reasonTextView, resignCheckButton, resignButton])

    mainView.snp.makeConstraints { make in
      make.width.equalTo(Size.screenWidth)
      make.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.top.equalToSuperview().offset(18)
      make.height.equalTo(22)
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

    reasonTextField.tintColor = .clear

    reasonTextField.delegate = self
    reasonTextView.textView.delegate = self

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
    reasonTextView.textView.inputAccessoryView = toolBar
  }

  @objc func tapDone() {
    self.endEditing(true)
  }
  @objc func tapCancel() {
    self.resignFirstResponder()
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
    return reasonArray[row].rawValue
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    reasonTextField.text = reasonArray[row].rawValue
  }
}

extension ResignInputCollectionViewCell: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    reasonTextView.textViewSelected()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    reasonTextView.textViewUnselected()
  }

  func textViewDidChange(_ textView: UITextView) {
    let size = CGSize(width: Size.screenWidth - 48, height: CGFloat.infinity)
    let estimatedSize = textView.sizeThatFits(size)

    reasonTextView.textViewResize()
    let height = reasonTextView.bounds.height
    delegate?.didTextViewChange(estimatedSize, height)
  }
}

extension ResignInputCollectionViewCell: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self = self else { return }
      self.reasonTextField.arrowImageView.transform = .init(rotationAngle: .pi)
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self = self else { return }
      self.reasonTextField.arrowImageView.transform = .init(rotationAngle: 0.0)
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }


}
