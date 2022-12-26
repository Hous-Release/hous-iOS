//
//  ProfileEditViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit
import BottomSheetKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileEditViewController: UIViewController {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  let viewModel: ProfileEditViewModel
  let actionDetected = PublishSubject<ProfileEditActionControl>()
  
  //MARK: Network
  
  private let profileRepository = ProfileRepositoryImp()
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  //MARK: UI Components
  
  private let datePicker = UIDatePicker()
  
  private let navigationBar = ProfileEditNavigationBarView()
  
  private let profileEditStackView = UIStackView().then {
    $0.alignment = .fill
    $0.distribution = .equalSpacing
    $0.axis = .vertical
    $0.spacing = 2
  }
  
  private var nameTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    let attrPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor : Colors.g5.color])
    textfield.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    textfield.attributedPlaceholder = attrPlaceholder
    return textfield
  }()
  
  private var birthdayTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    let attrPlaceholder = NSAttributedString(string: "생년월일", attributes: [NSAttributedString.Key.foregroundColor : Colors.g5.color, NSAttributedString.Key.font : Fonts.SpoqaHanSansNeo.medium.font(size: 16)])
    textfield.font = Fonts.Montserrat.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    textfield.attributedPlaceholder = attrPlaceholder
    return textfield
  }()
  
  private var mbtiTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    let attrPlaceholder = NSAttributedString(string: "MBTI", attributes: [NSAttributedString.Key.foregroundColor : Colors.g5.color])
    textfield.font = Fonts.Montserrat.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    textfield.attributedPlaceholder = attrPlaceholder
    return textfield
  }()
  
  private var jobTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    let attrPlaceholder = NSAttributedString(string: "직업", attributes: [NSAttributedString.Key.foregroundColor : Colors.g5.color])
    textfield.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    textfield.attributedPlaceholder = attrPlaceholder
    return textfield
  }()
  
  private var statusTextView = ProfileEditTextViewObject()
  
  private var statusTextCountLabel = UILabel().then {
    $0.text = "0/40"
    $0.font = Fonts.Montserrat.medium.font(size: 12)
    $0.textColor = Colors.g5.color
  }
  
  private var statusTextInvalidMessageLabel = UILabel().then {
    $0.textColor = Colors.red.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }
  
  //MARK: Initalizer
  
  init(data: ProfileModel) {
    self.viewModel = ProfileEditViewModel(data: data)
    super.init(nibName: nil, bundle: nil)
    setInitialData(data: data)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK: Life Cycle
  
  override func viewDidLoad(){
    super.viewDidLoad()
    setup()
    bind()
    render()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.setTabBarIsHidden(isHidden: true)
  }
  
  //MARK: Setup UI
  
  private func setInitialData(data: ProfileModel) {
    nameTextField.text = data.userName
    birthdayTextFieldSet(date: data.birthday)
    configureDatePicker(date: data.birthday ?? Date())
    birthdayTextField.birthdayPublicButton.isSelected = data.birthdayPublic
    mbtiTextField.text = data.mbti
    jobTextField.text = data.userJob
    
    [nameTextField, birthdayTextField, mbtiTextField, jobTextField].forEach {
      if $0.text!.isEmpty {
        $0.textFieldEmpty()
      } else {
        $0.textFieldFilled()
      }
    }
    if (data.statusMessage == nil) {
      statusTextView.isEmptyState = true
      statusTextView.textView.text = statusTextView.placeHolderString
      statusTextView.textView.textColor = Colors.g5.color
      statusTextView.textViewResize()
    } else {
      statusTextView.isEmptyState = false
      statusTextView.textView.text = data.statusMessage
      statusTextCountLabel.text = "\(String(describing: data.statusMessage!.count))/40"
      statusTextView.textViewResize()
    }
    
    if statusTextView.isEmptyState {
      statusTextView.textViewEmpty()
    } else {
      statusTextView.textViewFilled()
    }
  }

  
  private func setup() {
    self.view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    birthdayTextField.delegate = self
    setUpBirthDayTextField()
  }
  private func setUpBirthDayTextField() {

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

    birthdayTextField.inputView = datePicker
    birthdayTextField.inputAccessoryView = toolBar
  }

  @objc private func didTapCancel() {
    birthdayTextField.endEditing(true)
    birthdayTextFieldSet(date: nil)
    self.actionDetected.onNext(.birthdayTextFieldEdited(date: nil))
  }

  @objc private func setDate() {
    birthdayTextField.endEditing(true)
    birthdayTextFieldSet(date: datePicker.date)
    self.actionDetected.onNext(.birthdayTextFieldEdited(date: datePicker.date))
  }
  
  //MARK: Bind
  
  private func bind() {
    
    // input
    
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asSignal(onErrorJustReturn: ())
    
    nameTextField.rx.controlEvent(.editingDidBegin)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.nameTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    nameTextField.rx.controlEvent(.editingDidEnd)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: {[weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.nameTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    nameTextField.rx.text.orEmpty
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] text in
        guard let self = self else { return }
        self.actionDetected.onNext(.nameTextFieldEdited(text: text))
      })
      .disposed(by: disposeBag)
    
    birthdayTextField.rx.controlEvent(.editingDidBegin)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: {[weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.birthdayTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    birthdayTextField.rx.controlEvent(.editingDidEnd)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: {[weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.birthdayTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    birthdayTextField.birthdayPublicButton.rx.tap
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.birthdayPublicEdited(isPublic: !self.birthdayTextField.birthdayPublicButton.isSelected))
      })
      .disposed(by: disposeBag)
    
    mbtiTextField.rx.controlEvent(.editingDidBegin)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: {[weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.mbtiTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    mbtiTextField.rx.controlEvent(.editingDidEnd)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: {[weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.mbtiTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    mbtiTextField.rx.text.orEmpty
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] text in
        guard let self = self else { return }
        self.actionDetected.onNext(.mbtiTextFieldEdited(text: text))
      })
      .disposed(by: disposeBag)
    
    jobTextField.rx.controlEvent(.editingDidBegin)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.jobTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    jobTextField.rx.controlEvent(.editingDidEnd)
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.jobTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    jobTextField.rx.text.orEmpty
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] text in
        guard let self = self else { return }
        self.actionDetected.onNext(.jobTextFieldEdited(text: text))
      })
      .disposed(by: disposeBag)
    
    statusTextView.textView.rx.didBeginEditing
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.statusTextViewSelected)
      })
      .disposed(by: disposeBag)
    
    statusTextView.textView.rx.didEndEditing
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.statusTextViewUnselected)
      })
      .disposed(by: disposeBag)
    
    statusTextView.textView.rx.didChange
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        let text = self.statusTextView.textView.text ?? ""
        self.actionDetected.onNext(.statusTextViewEdited(text: text))
      })
      .disposed(by: disposeBag)
    
    navigationBar.saveButton.rx.tap
      .observe(on:MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabSave)
      })
      .disposed(by: disposeBag)
    
    navigationBar.navigationBackButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabBack)
      })
      .disposed(by: disposeBag)
    
    self.view.rx.tapGesture()
      .when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.actionDetected.onNext(.didTabBackgroundView)
      })
      .disposed(by: disposeBag)
    
    let input = ProfileEditViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.actionControl
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.doNavigation(action: $0)
        self.textFieldModeControl(action: $0)
        self.textFieldCountConstraint(action: $0)
        self.textViewControl(action: $0)
        self.birthdayButtonControl(action: $0)
        self.keyPadControl(action: $0)
      })
      .disposed(by: disposeBag)
    
    output.isModifiedObservable
      .bind(onNext: {[weak self] isModified in
        guard let self = self else { return }
        if self.isAllOptionValid() {
          self.navigationBar.saveButton.isEnabled = isModified
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  
  //MARK: Render
  
  private func render() {
    [nameTextField, birthdayTextField, mbtiTextField, jobTextField].forEach {profileEditStackView.addArrangedSubview($0)}
    
    view.addSubViews([navigationBar, profileEditStackView, statusTextView, statusTextCountLabel])
    
    navigationBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    profileEditStackView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(24)
    }
    
    statusTextView.snp.makeConstraints { make in
      make.top.equalTo(profileEditStackView.snp.bottom).offset(30)
      make.leading.trailing.equalToSuperview().inset(24)
    }
    
    statusTextCountLabel.snp.makeConstraints { make in
      make.top.equalTo(statusTextView.snp.bottom).offset(7)
      make.trailing.equalToSuperview().offset(-34)
    }
  }
  
  //MARK: TextField Methods
  
  private func isAllOptionValid() -> Bool {
    for textField in [nameTextField, birthdayTextField, mbtiTextField, jobTextField] {
      if textField.isFloatingErrorMessage {
        return false
      }
    }
    
    return statusTextView.isFloatingErrorMessage ? false : true
  }
  
  private func textFieldModeControl(action: ProfileEditActionControl) {
    switch action {
    case .nameTextFieldSelected, .nameTextFieldUnselected:
      if nameTextField.text!.isEmpty {
        nameTextField.textFieldEmpty()
      } else {
        nameTextField.textFieldFilled()
      }
    case .birthdayTextFieldSelected, .birthdayTextFieldUnselected:
      if birthdayTextField.text!.isEmpty {
        birthdayTextField.textFieldEmpty()
      } else {
        birthdayTextField.textFieldFilled()
      }
      
    case .mbtiTextFieldSelected, .mbtiTextFieldUnselected:
      if mbtiTextField.text!.isEmpty {
        mbtiTextField.textFieldEmpty()
      } else {
        mbtiTextField.textFieldFilled()
      }
    case .jobTextFieldSelected, .jobTextFieldUnselected:
      if jobTextField.text!.isEmpty {
        jobTextField.textFieldEmpty()
      } else {
        jobTextField.textFieldFilled()
      }
    case .statusTextViewSelected:
      statusTextView.textViewSelected()
      if statusTextView.isEmptyState {
        statusTextView.textViewEmpty()
      } else {
        statusTextView.textViewFilled()
      }
    case .statusTextViewUnselected:
      statusTextView.textViewUnselected()
      if statusTextView.isEmptyState {
        statusTextView.textViewEmpty()
      } else {
        statusTextView.textViewFilled()
      }
    default:
      return
    }
  }
  
  private func birthdayTextFieldSet(date: Date?) {

//    if (date == nil) {
//      birthdayTextField.text = nil
//    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    birthdayTextField.text = (date != nil) ? dateFormatter.string(from: date!) : nil
    let attributedString = NSMutableAttributedString(string: birthdayTextField.text ?? "")
    attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSRange(location: 0, length: attributedString.length))
    birthdayTextField.attributedText = attributedString
  }
  
  private func textFieldCountConstraint(action: ProfileEditActionControl) {
    var text: String
    var attributeName: String
    var maxCount: Int
    var textField: ProfileEditTextField?
    
    switch action {
    case let .nameTextFieldEdited(data):
      text = data
      attributeName = "닉네임은"
      maxCount = 3
      textField = nameTextField
      
    case let .mbtiTextFieldEdited(data):
      text = data
      attributeName = "MBTI는"
      maxCount = 4
      textField = mbtiTextField
      
    case let .jobTextFieldEdited(data):
      text = data
      attributeName = "직업은"
      maxCount = 3
      textField = jobTextField
      
    case let .statusTextViewEdited(data):
      text = data
      attributeName = "자기소개는"
      maxCount = 40
      
    default:
      return
    }
    
    guard let textField = textField else {
      if statusTextView.textView.text.isEmpty {
        statusTextView.textViewEmpty()
      } else {
        statusTextView.textViewFilled()
      }
      if text.count > maxCount {
        self.view.addSubview(statusTextInvalidMessageLabel)
        statusTextView.isFloatingErrorMessage = true
        
        statusTextInvalidMessageLabel.snp.makeConstraints { make in
          make.leading.equalTo(statusTextView.snp.leading).offset(4)
          make.top.equalTo(statusTextView.snp.bottom).offset(8)
        }
        
        statusTextInvalidMessageLabel.text = "\(attributeName) \(maxCount)자 이내로 입력해주세요!"
      
        navigationBar.saveButton.isEnabled = false
      
      } else {
        statusTextInvalidMessageLabel.removeFromSuperview()
        statusTextView.isFloatingErrorMessage = false
        if viewModel.isModifiedData && isAllOptionValid(){
          navigationBar.saveButton.isEnabled = true
        }
      }
      return
    }
    
    if textField.text!.isEmpty {
      textField.textFieldEmpty()
    } else {
      textField.textFieldFilled()
    }
    
    if text.count > maxCount {
      textField.invalidDataOn(attributeName: attributeName, count: maxCount)
      
      navigationBar.saveButton.isEnabled = false
    
    }
    else if text.count == 0 && textField == nameTextField {
      navigationBar.saveButton.isEnabled = false
    } else {
      textField.invalidDataOff()
      if viewModel.isModifiedData && isAllOptionValid(){
        navigationBar.saveButton.isEnabled = true
      }
    }
  }
  
  private func textViewControl(action: ProfileEditActionControl) {
    switch action {
    case .statusTextViewEdited:
      let count = statusTextView.textView.text.count
      self.statusTextCountLabel.text = "\(count)/40"
      statusTextView.textViewResize()
      statusTextView.textEmptyControl()
    default:
      return
    }
  }
  
  private func configureDatePicker(date: Date) {
    self.datePicker.date = date
    self.datePicker.datePickerMode = .date
    self.datePicker.preferredDatePickerStyle = .wheels
    self.datePicker.locale = Locale(identifier: "ko-KR")
  }
  
  private func saveButtonControl(isModified: Bool) {
    if isModified && isAllOptionValid() {
      navigationBar.saveButton.isEnabled = true
    } else {
      navigationBar.saveButton.isEnabled = false
    }
  }
  
  private func birthdayButtonControl(action: ProfileEditActionControl) {
    switch action {
    case let .birthdayPublicEdited(isPublic):
      if isPublic {
        self.birthdayTextField.birthdayPublicButton.isSelected = true
      } else {
        self.birthdayTextField.birthdayPublicButton.isSelected = false
      }
    default:
      return
    }
  }
  
  private func doNavigation(action: ProfileEditActionControl) {
    switch action {
    case .didTabSave:
      profileRepository.putProfileEditInfo(data: viewModel.modifiedData)
      setTabBarIsHidden(isHidden: false)
      self.navigationController?.popViewController(animated: true)
      
    case .didTabBack:
      let backButtonPopUpModel = DefaultPopUpModel(
        cancelText: "계속 수정하기",
        actionText: "나가기",
        title: "수정사항이 저장되지 않았어요!",
        subtitle: "프로필 수정을 취소하려면 나가기 버튼을 눌러주세요."
      )
      
      let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: backButtonPopUpModel)
      
      presentPopUp(popUpType) { [weak self] actionType in
        switch actionType {
        case .action:
          self?.view.endEditing(true)
          self?.setTabBarIsHidden(isHidden: false)
          self?.navigationController?.popViewController(animated: true)
        case .cancel:
          break
        }
      }
    default:
      return
    }
  }
  
  private func keyPadControl(action: ProfileEditActionControl) {
    switch action {
    case .didTabBackgroundView:
      self.view.endEditing(true)
    default:
      return
    }
  }
}

extension ProfileEditViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }
}
