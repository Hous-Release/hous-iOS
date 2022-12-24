//
//  EnterInfoView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

import SnapKit
import Then

class EnterInfoView: UIView {

  var navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "회원 정보 입력")
    return navBar
  }()

  private let contentView = UIView()

  private let nicknameLabel: UILabel = {
    var label = UILabel()
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    label.textColor = Colors.black.color
    label.text = "닉네임"
    return label
  }()

  var nicknameTextfield: UnderlinedTextField = {
    var textfield = UnderlinedTextField()
    textfield.placeholder = "Hous-에서 사용할 이름을 입력해 주세요."
    textfield.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    return textfield
  }()

  var nicknameErrorLabel = UILabel().then {
    $0.text = "*닉네임은 3자 이하로 설정해 주세요"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.red.color
    $0.isHidden = true
  }

  private let birthdayLabel: UILabel = {
    var label = UILabel()
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    label.textColor = Colors.black.color
    label.text = "생년월일"
    return label
  }()

  var birthdayTextfield: UnderlinedTextField = {
    var textfield = UnderlinedTextField()
    textfield.placeholder = "YYYY / MM / DD"
    textfield.font = Fonts.Montserrat.regular.font(size: 14)
    textfield.textColor = Colors.black.color
    return textfield
  }()

  let datePicker: UIDatePicker = {
    let datePicker = UIDatePicker(
      frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216)
    )
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .wheels
    return datePicker
  }()

//  var checkBirthDayButton = UIButton(configuration: .plain()).then {
//
//  var attrString = AttributedString("생일 정보 비공개")
//    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
//    attrString.foregroundColor = Colors.g5.color
//    $0.configuration?.attributedTitle = attrString
//    $0.configuration?.baseBackgroundColor = Colors.white.color
//
//  $0.configurationUpdateHandler = { btn in
//      switch btn.state {
//      case .normal:
//        btn.configuration?.image = Images.icCheckNo.image
//      case .selected:
//        btn.configuration?.image = Images.icCheckYes.image
//      default:
//        break
//      }
//    }
//    $0.configuration?.imagePadding = 8
//  }

  var nextButton = NextButton("다음으로").then {
    $0.isEnabled = false
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setUp()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp() {

    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.sizeToFit()

    let doneButton = UIBarButtonItem(
      title: "저장",
      style: .plain,
      target: self,
      action: #selector(setDate)
    )

    let spaceButton = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )

    let cancelButton = UIBarButtonItem(
      title: "생일 정보 삭제",
      style: .plain, target: self,
      action: #selector(didTapCancel)
    )
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)

    birthdayTextfield.inputView = datePicker
    birthdayTextfield.inputAccessoryView = toolBar
    nicknameTextfield.rightView?.isHidden = true
    birthdayTextfield.rightView?.isHidden = true
  }

  @objc func setDate() {
      self.endEditing(true)
  }

  @objc
  func didTapCancel() {
    birthdayTextfield.text = nil
    self.endEditing(true)
  }

  private func render() {

    addSubViews([navigationBar, contentView, nextButton])
    contentView.addSubViews([
      nicknameLabel,
      nicknameTextfield,
      nicknameErrorLabel,
      birthdayLabel,
      birthdayTextfield
    ])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    contentView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(navigationBar.snp.bottom).offset(50)
    }

    nicknameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.top.equalToSuperview()
    }

    nicknameTextfield.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
      make.height.equalTo(38)
    }

    nicknameErrorLabel.snp.makeConstraints { make in
      make.leading.equalTo(nicknameTextfield.snp.leading)
      make.top.equalTo(nicknameTextfield.snp.bottom).offset(6)
    }

    birthdayLabel.snp.makeConstraints { make in
      make.leading.equalTo(nicknameLabel.snp.leading)
      make.top.equalTo(nicknameErrorLabel.snp.bottom).offset(40)
    }

    birthdayTextfield.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.top.equalTo(birthdayLabel.snp.bottom).offset(10)
      make.height.equalTo(38)
    }

//    checkBirthDayButton.snp.makeConstraints { make in
//      make.top.equalTo(birthdayTextfield.snp.bottom).offset(4)
//      make.leading.equalToSuperview().offset(12)
//      make.bottom.equalToSuperview()
//    }

    nextButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(86)
    }
  }
}
