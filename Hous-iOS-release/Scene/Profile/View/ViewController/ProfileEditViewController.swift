//
//  ProfileEditViewController.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/22.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileEditViewController: UIViewController {
  
  //MARK: RX Components
  
  let disposeBag = DisposeBag()
  let viewModel: ProfileEditViewModel
  
  
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
    $0.spacing = 30
  }
  
  private var nameTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    textfield.placeholder = "이름"
    textfield.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    return textfield
  }()
  
  private var birthdayTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    textfield.placeholder = "생년월일"
    textfield.font = Fonts.Montserrat.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    return textfield
  }()
  
  private var mbtiTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    textfield.placeholder = "MBTI"
    textfield.font = Fonts.Montserrat.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    return textfield
  }()
  
  private var jobTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    textfield.placeholder = "직업"
    textfield.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    return textfield
  }()
  
  private var statusTextField: ProfileEditTextField = {
    var textfield = ProfileEditTextField()
    textfield.placeholder = "자기소개"
    textfield.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    textfield.textColor = Colors.black.color
    textfield.returnKeyType = .done
    textfield.rightView?.isHidden = true
    return textfield
  }()
  
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
  }
  
  //MARK: Setup UI
  
  private func setInitialData(data: ProfileModel) {
    nameTextField.text = data.userName
    birthdayTextFieldSet(date: data.birthday)
    configureDatePicker(date: data.birthday ?? Date())
    birthdayTextField.birthdayPublicButton.isSelected = data.birthdayPublic
    mbtiTextField.text = data.mbti
    jobTextField.text = data.userJob
    statusTextField.text = data.statusMessage
  }
  
  private func setup() {
    self.view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    birthdayTextField.delegate = self
    birthdayTextField.inputView = self.datePicker
  }
  
  //MARK: Bind
  
  private func bind() {
    
    // input
    
    let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in }
      .asSignal(onErrorJustReturn: ())
    
    let actionDetected = PublishSubject<ProfileEditActionControl>()
    
    nameTextField.rx.controlEvent(.editingDidBegin)
      .bind(onNext: {
        actionDetected.onNext(.nameTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    nameTextField.rx.controlEvent(.editingDidEnd)
      .bind(onNext: {
        actionDetected.onNext(.nameTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    nameTextField.rx.text.orEmpty
      .bind(onNext: { text in
        actionDetected.onNext(.nameTextFieldEdited(text: text))
      })
      .disposed(by: disposeBag)
    
    birthdayTextField.rx.controlEvent(.editingDidBegin)
      .bind(onNext: {
        actionDetected.onNext(.birthdayTextFieldSelected)
        
      })
      .disposed(by: disposeBag)
    
    birthdayTextField.rx.controlEvent(.editingDidEnd)
      .bind(onNext: {
        actionDetected.onNext(.birthdayTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    birthdayTextField.birthdayPublicButton.rx.tap
      .bind(onNext: {
        actionDetected.onNext(.birthdayPublicEdited(isPublic: !self.birthdayTextField.birthdayPublicButton.isSelected))
      })
      .disposed(by: disposeBag)
    
    datePicker.rx.date
      .bind(onNext: { date in
        actionDetected.onNext(.birthdayTextFieldEdited(date: date))
      })
      .disposed(by: disposeBag)
    
    mbtiTextField.rx.controlEvent(.editingDidBegin)
      .bind(onNext: {
        actionDetected.onNext(.mbtiTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    mbtiTextField.rx.controlEvent(.editingDidEnd)
      .bind(onNext: {
        actionDetected.onNext(.mbtiTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    mbtiTextField.rx.text.orEmpty
      .bind(onNext: { text in
        actionDetected.onNext(.mbtiTextFieldEdited(text: text))
      })
      .disposed(by: disposeBag)
    
    jobTextField.rx.controlEvent(.editingDidBegin)
      .bind(onNext: {
        actionDetected.onNext(.jobTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    jobTextField.rx.controlEvent(.editingDidEnd)
      .bind(onNext: {
        actionDetected.onNext(.jobTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    jobTextField.rx.text.orEmpty
      .bind(onNext: { text in
        actionDetected.onNext(.jobTextFieldEdited(text: text))
      })
      .disposed(by: disposeBag)
    
    statusTextField.rx.controlEvent(.editingDidBegin)
      .bind(onNext: {
        actionDetected.onNext(.statusTextViewSelected)
      })
      .disposed(by: disposeBag)
    
    statusTextField.rx.controlEvent(.editingDidEnd)
      .bind(onNext: {
        actionDetected.onNext(.statusTextViewUnselected)
      })
      .disposed(by: disposeBag)
    
    let input = ProfileEditViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.actionControl
      .bind(onNext: {[weak self] in
        guard let self = self else { return }
        self.textFieldModeControl(action: $0)
        self.textFieldCountConstraint(action: $0)
        self.birthdayButtonControl(action: $0)
        self.birthdayTextFieldControl(action: $0)
      })
      .disposed(by: disposeBag)
    
    output.isModifiedObservable
      .bind(onNext: {[weak self] isModified in
        guard let self = self else { return }
        self.navigationBar.saveButton.isEnabled = isModified
      })
      .disposed(by: disposeBag)
    
  }
  
  
  //MARK: Render
  
  private func render() {
    [nameTextField, birthdayTextField, mbtiTextField, jobTextField, statusTextField].forEach {profileEditStackView.addArrangedSubview($0)}
    
    view.addSubViews([navigationBar, profileEditStackView])
    
    navigationBar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    profileEditStackView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(260)
    }
  }
  
  //MARK: TextField Methods
  
  private func textFieldModeControl(action: ProfileEditActionControl) {
    switch action {
    case .nameTextFieldSelected:
      nameTextField.textFieldSelected()
    case .nameTextFieldUnselected:
      nameTextField.textFieldUnselected()
    case .birthdayTextFieldSelected:
      birthdayTextField.textFieldSelected()
    case .birthdayTextFieldUnselected:
      birthdayTextField.textFieldUnselected()
    case .mbtiTextFieldSelected:
      mbtiTextField.textFieldSelected()
    case .mbtiTextFieldUnselected:
      mbtiTextField.textFieldUnselected()
    case .jobTextFieldSelected:
      jobTextField.textFieldSelected()
    case .jobTextFieldUnselected:
      jobTextField.textFieldUnselected()
    case .statusTextViewSelected:
      statusTextField.textFieldSelected()
    case .statusTextViewUnselected:
      statusTextField.textFieldUnselected()
    default:
      return
    }
  }
  
  private func birthdayTextFieldSet(date: Date?) {
    if (date == nil) {
      birthdayTextField.text = nil
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    birthdayTextField.text = dateFormatter.string(from: date ?? Date())
    let attributedString = NSMutableAttributedString(string: birthdayTextField.text ?? "")
    attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSRange(location: 0, length: attributedString.length))
    birthdayTextField.attributedText = attributedString
  }
  
  private func textFieldCountConstraint(action: ProfileEditActionControl) {
    var text: String
    var maxCount: Int
    var textField: UITextField
    
    switch action {
    case let .nameTextFieldEdited(data):
      text = data
      maxCount = 3
      textField = nameTextField
      
    case let .mbtiTextFieldEdited(data):
      text = data
      maxCount = 4
      textField = mbtiTextField
      
    case let .jobTextFieldEdited(data):
      text = data
      maxCount = 3
      textField = jobTextField
      
    default:
      return
    }
    
    if text.count > maxCount {
      let index = text.index(text.startIndex, offsetBy: maxCount)
      textField.text = String(text[..<index])
    }
  }
  
  private func configureDatePicker(date: Date) {
    self.datePicker.date = date
    self.datePicker.datePickerMode = .date
    self.datePicker.preferredDatePickerStyle = .wheels
  }
  
  private func saveButtonControl(isModified: Bool) {
    if isModified {
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
  
  private func birthdayTextFieldControl(action: ProfileEditActionControl) {
    switch action {
    case let .birthdayTextFieldEdited(date):
      birthdayTextFieldSet(date: date)
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
