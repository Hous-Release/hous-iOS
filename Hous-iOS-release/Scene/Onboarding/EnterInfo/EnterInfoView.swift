//
//  EnterInfoView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

import SnapKit

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
    textfield.placeholder = "Hous-에서 사용할 이름을 입력해주세요."
    textfield.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    textfield.textColor = Colors.black.color
    return textfield
  }()

  private let birthdayLabel: UILabel = {
    var label = UILabel()
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    label.textColor = Colors.black.color
    label.text = "생년월일"
    return label
  }()

  var birthdayTextfield: UnderlinedTextField = {
    var textfield = UnderlinedTextField()
    textfield.placeholder = "YYYY/MM/DD"
    textfield.font = Fonts.Montserrat.regular.font(size: 14)
    textfield.textColor = Colors.black.color
    return textfield
  }()

  let datePicker: UIDatePicker = {
    return UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 216))
  }()

  var checkBirthDayButton: UIButton = {
    var button = UIButton()
    button.setImage(Images.icCheckNo.image, for: .normal)
    button.setImage(Images.icCheckYes.image, for: .selected)
    button.isSelected = false
    return button
  }()

  private let guideLabel: UILabel = {
    var label = UILabel()
    label.textColor = Colors.g5.color
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    label.text = "생년월일 호미들에게 공개"
    return label
  }()

  var nextButton: UIButton = {
    var button = UIButton()
    button.setTitle("다음으로", for: .normal)
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    button.titleLabel?.textColor = Colors.white.color
    button.setBackgroundColor(Colors.g4.color, for: .disabled)
    button.setBackgroundColor(Colors.blue.color, for: .normal)
    button.isEnabled = false
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setUp()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp() {
    birthdayTextfield.setDatePicker(target: self, selector: #selector(setDate), datePicker: datePicker)
    datePicker.addTarget(self, action: #selector(handleDatePickerTap), for: .editingDidBegin)
    nicknameTextfield.rightView?.isHidden = true
    birthdayTextfield.rightView?.isHidden = true
  }

  @objc func setDate() {
      self.endEditing(true)
  }
  @objc func handleDatePickerTap() {
    datePicker.resignFirstResponder()
  }

  private func render() {

    addSubViews([navigationBar, contentView, nextButton])
    contentView.addSubViews([nicknameLabel, nicknameTextfield,
                             birthdayLabel, birthdayTextfield,
                            checkBirthDayButton, guideLabel])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    contentView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
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

    birthdayLabel.snp.makeConstraints { make in
      make.leading.equalTo(nicknameLabel.snp.leading)
      make.top.equalTo(nicknameTextfield.snp.bottom).offset(40)
    }

    birthdayTextfield.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.top.equalTo(birthdayLabel.snp.bottom).offset(10)
      make.height.equalTo(38)
    }

    checkBirthDayButton.snp.makeConstraints { make in
      make.top.equalTo(birthdayTextfield.snp.bottom)
      make.size.equalTo(44)
      make.leading.equalToSuperview().offset(12)
    }

    guideLabel.snp.makeConstraints { make in
      make.centerY.equalTo(checkBirthDayButton.snp.centerY)
      make.leading.equalTo(checkBirthDayButton.snp.trailing)
      make.bottom.equalToSuperview()
    }

    nextButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(86)
    }
  }
}
