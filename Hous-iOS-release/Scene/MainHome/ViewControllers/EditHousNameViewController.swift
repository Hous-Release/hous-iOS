//
//  EditHousNameViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/17.
//

import UIKit
import RxSwift
import RxRelay

class EditHousNameViewController: UIViewController {
  
  //MARK: Var & Let
  private let saveButtonDidTapped = PublishSubject<String>()
  private let viewModel = EditHousNameViewModel()
  private let disposeBag = DisposeBag()
  
  
  //MARK: UI Components
  private let navigationBar: NavBarWithBackButtonView = {
    let navBar = NavBarWithBackButtonView(title: "우리 집 별명 바꾸기", rightButtonText: "저장")
    return navBar
  }()
  
  private let descriptionLabel = UILabel().then {
    $0.text = "함께 사는 우리 집을 위한 별명을 지어주세요!"
    $0.textColor = Colors.g5.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.dynamicFont(fontSize: 14, weight: .medium)
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
  
  private let blueLine = UIView().then {
    $0.backgroundColor = Colors.blue.color
  }
  
  
  //MARK: Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    setDelegate()
    configureButtonAction()
    configUI()
    bindUI()
  }
  
  private func setDelegate() {
    navigationBar.delegate = self
  }
    
  private func configUI() {
    view.addSubViews([
      navigationBar,
      descriptionLabel,
      textField,
      blueLine,
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
    let input = EditHousNameViewModel.Input(
      roomName: textField.rx.text.orEmpty.distinctUntilChanged().asDriver(onErrorJustReturn: ""),
      saveButtonDidTapped: saveButtonDidTapped
    )
    
    let output = self.viewModel.transform(input: input)
    
    output.textCountLabelText
      .drive(textcountLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.text
      .map { $0 }
      .drive(textField.rx.text)
      .disposed(by: disposeBag)
    
    output.updatedRoom
      .drive(onNext: { _ in
        self.backButtonDidTappedWithoutPopUp()
      })
      .disposed(by: disposeBag)
  }
}

extension EditHousNameViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTapped() {
    let popUp = QuitPopViewController()
    popUp.configPopupTexts(
      titleLabelText: "앗, 잠깐! 이대로 나가면\n우리 집 별명이 저장되지 않아요!",
      subtitleLabelText: "정말 취소하려면 나가기 버튼을 눌러주세요",
      continueButtonText: "돌아가기",
      cancelButtonText: "나가기"
    )
    popUp.delegate = self
    popUp.modalTransitionStyle = .crossDissolve
    popUp.modalPresentationStyle = .overFullScreen
    
    present(popUp, animated: true)
  }
  
  func backButtonDidTappedWithoutPopUp() {
    self.navigationController?.popViewController(animated: true)
  }
}

extension EditHousNameViewController: QuitPopViewControllerDelegate {
  func cancelButtonDidTapped() {
    self.navigationController?.popViewController(animated: true)
  }
}
