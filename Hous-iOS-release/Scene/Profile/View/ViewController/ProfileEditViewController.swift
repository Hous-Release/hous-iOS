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
  var viewModel = ProfileEditViewModel()
  var data: ProfileModel
  
  //MARK: UI Templetes
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  //MARK: UI Components
  
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
    textfield.placeholder = "yyyy/MM/dd"
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
    self.data = data
    super.init(nibName: nil, bundle: nil)
    
    nameTextField.text = self.data.userName
    birthdayTextFieldSet(date: self.data.birthday)
    
    
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
  
  //MARK: Setup UI
  
  private func setup() {
    self.view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
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
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.birthdayTextField.birthdayPublicButton.isSelected = !self.birthdayTextField.birthdayPublicButton.isSelected
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
    
    statusTextField.rx.controlEvent(.editingDidBegin)
      .bind(onNext: {
        actionDetected.onNext(.statusTextFieldSelected)
      })
      .disposed(by: disposeBag)
    
    statusTextField.rx.controlEvent(.editingDidEnd)
      .bind(onNext: {
        actionDetected.onNext(.statusTextFieldUnselected)
      })
      .disposed(by: disposeBag)
    
    
    
    let input = ProfileEditViewModel.Input(
      viewWillAppear: viewWillAppear,
      actionDetected: actionDetected,
      data: self.data
    )
    
    // output
    
    let output = viewModel.transform(input: input)
    
    output.actionControl
      .bind(onNext: {[weak self] in
        self?.textFieldControl(action: $0)
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
  
  private func textFieldControl(action: ProfileEditActionControl) {
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
    case .statusTextFieldSelected:
      statusTextField.textFieldSelected()
    case .statusTextFieldUnselected:
      statusTextField.textFieldUnselected()
    default:
      return
    }
  }
  
  private func birthdayTextFieldSet(date: Date?) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    birthdayTextField.text = dateFormatter.string(from: date ?? Date())
    let attributedString = NSMutableAttributedString(string: birthdayTextField.text ?? "")
    attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(2), range: NSRange(location: 0, length: attributedString.length))
    birthdayTextField.attributedText = attributedString
  }
}
