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

final class EditHousNameViewController: BaseViewController {

  // MARK: Var & Let

  private let saveButtonDidTapped = PublishSubject<String>()
  private let viewModel = EditHousNameViewModel()
  private let disposeBag = DisposeBag()
  private let roomName: String
  private let initialRoomName: String?

  // MARK: UI Components
  private let navigationBar = NavBarWithBackButtonView(
    title: "우리 집 별명 수정",
    rightButtonText: "저장")

  private let descriptionLabel = UILabel().then {
    $0.text = "함께 사는 우리 집을 위한 별명을 지어주세요."
    $0.textColor = Colors.g5.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }

  private lazy var textField = HousTextField(nil, roomName,
                                             useMaxCount: true,
                                             maxCount: 8,
                                             exceedString: "방 이름은 8자 이내로 입력해주세요!").then {
    $0.placeholder = "우리 집 별명"
    $0.textAlignment = .center
  }

  // MARK: Life Cycles
  init(roomName: String) {
    self.roomName = roomName
    self.initialRoomName = roomName
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
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
  }

  private func showQuitPopUp() {
    let defaultPopUpModel = DefaultPopUpModel(
      cancelText: "계속 수정하기",
      actionText: "나가기",
      title: "앗, 잠깐! 이대로 나가면\n우리 집 별명이 저장되지 않아요!",
      subtitle: "수정을 취소하려면 나가기 버튼을 눌러주세요."
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
  }

  private func configUI() {
    self.view.backgroundColor = .systemBackground

    view.addSubViews([
      navigationBar,
      descriptionLabel,
      textField
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
      make.leading.trailing.equalToSuperview().inset(95)
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
        if self.textField.text == self.initialRoomName {
          self.navigationController?.popViewController(animated: true)
        } else {
          self.showQuitPopUp()
        }
      })
      .disposed(by: disposeBag)

    let input = EditHousNameViewModel.Input(
      roomName: textField.rx.text.orEmpty.distinctUntilChanged().asDriver(onErrorJustReturn: ""),
      saveButtonDidTapped: saveButtonDidTapped.do(onNext: { [weak self] _ in self?.showLoading() })
    )

    let output = self.viewModel.transform(input: input)

    output.isValidText
      .drive(onNext: { [weak self] isValidFlag in
        guard let self = self else { return }
        self.navigationBar.rightButton.isEnabled = isValidFlag
      })
      .disposed(by: disposeBag)

    output.updatedRoom
      .do(onNext: {[weak self] _ in self?.hideLoading() })
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
extension EditHousNameViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

    if textField.text != initialRoomName {
      showQuitPopUp()
      return false
    }

    return true
  }
}
