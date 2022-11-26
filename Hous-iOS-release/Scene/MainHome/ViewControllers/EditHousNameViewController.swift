//
//  EditHousNameViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/17.
//

import UIKit
import RxSwift
import RxRelay
import BottomSheetKit

class EditHousNameViewController: UIViewController {
  
  //MARK: Var & Let
  private let saveButtonDidTapped = PublishSubject<String>()
  private let viewModel = EditHousNameViewModel()
  private let disposeBag = DisposeBag()
  
  
  //MARK: UI Components
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "우리 집 별명 바꾸기")
    navBar.setRightButtonText(text: "저장")
    return navBar
  }()
  
  private let descriptionLabel = UILabel().then {
    $0.text = "함께 사는 우리 집을 위한 별명을 지어주세요!"
    $0.textColor = Colors.g5.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }
  
  private let textcountLabel = UILabel().then {
    $0.text = "0/8"
    $0.textColor = Colors.g5.color
    $0.font = Fonts.Montserrat.medium.font(size: 12)
    $0.dynamicFont(fontSize: 12, weight: .medium)
  }
  
  private let textField = UITextField().then {
    $0.textAlignment = .center
  }
  
  private let inValidTextLabel = UILabel().then {
    $0.isHidden = true
    $0.text = "방 이름은 8자 이내로 입력해주세요!"
    $0.textColor = Colors.red.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }
  
  private let blueLine = UIView().then {
    $0.backgroundColor = Colors.blue.color
  }
  
  
  //MARK: Life Cycles
  init(roomName: String) {
    textField.text = roomName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureButtonAction()
    configUI()
    bindUI()
  }
    
  private func configUI() {
    self.view.backgroundColor = .systemBackground
    
    view.addSubViews([
      navigationBar,
      descriptionLabel,
      textField,
      blueLine,
      inValidTextLabel,
      textcountLabel
    ])
    
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(80)
      make.centerX.equalToSuperview()
    }
    
    textField.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
      make.centerX.equalTo(descriptionLabel)
      make.leading.trailing.equalTo(blueLine)
    }
    
    blueLine.snp.makeConstraints { make in
      make.height.equalTo(2)
      make.top.equalTo(textField.snp.bottom).offset(7)
      make.leading.trailing.equalToSuperview().inset(95)
      make.centerX.equalTo(textField)
    }
    
    inValidTextLabel.snp.makeConstraints { make in
      make.top.equalTo(blueLine.snp.bottom).offset(8)
      make.leading.equalTo(blueLine)
    }
    
    textcountLabel.snp.makeConstraints { make in
      make.top.equalTo(blueLine.snp.bottom).offset(7)
      make.trailing.equalTo(blueLine)
    }
  }
  
  private func configureButtonAction() {
    navigationBar.rightButton.rx.tap
      .bind {
        let name = self.textField.text!
        self.saveButtonDidTapped.onNext(name)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindUI() {
    navigationBar.backButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        let defaultPopUpModel = DefaultPopUpModel(
          cancelText: "돌아가기",
          actionText: "나가기",
          title: "앗, 잠깐! 이대로 나가면\n우리 집 별명이 저장되지 않아요!",
          subtitle: "정말 취소하려면 나가기 버튼을 눌러주세요."
        )
        let popUpType = PopUpType.defaultPopUp(defaultPopUpModel: defaultPopUpModel)

        self.presentPopUp(popUpType) { [weak self] actionType in
          switch actionType {
          case .action:
            self?.navigationController?.popViewController(animated: true)
          case .cancel:
            break
          }
        }
      })
      .disposed(by: disposeBag)
    
    let input = EditHousNameViewModel.Input(
      roomName: textField.rx.text.orEmpty.distinctUntilChanged().asDriver(onErrorJustReturn: ""),
      saveButtonDidTapped: saveButtonDidTapped
    )
    
    let output = self.viewModel.transform(input: input)
    
    output.isValidText
      .drive(onNext: { [weak self] isValidFlag in
        guard let self = self else { return }
        self.navigationBar.rightButton.isEnabled = isValidFlag
        self.inValidTextLabel.isHidden = isValidFlag
      })
      .disposed(by: disposeBag)
    
    output.textCountLabelText
      .drive(textcountLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.updatedRoom
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
