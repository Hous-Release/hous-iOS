//
//  EnterRoomCodeViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit
import RxCocoa
import ReactorKit
import BottomSheetKit

final class EnterRoomCodeViewController: UIViewController, View {
  typealias Reactor = EnterRoomCodeViewReactor

  var disposeBag = DisposeBag()
  var mainView = EnterRoomTextFieldView(roomType: .exist)

  override func loadView() {
    super.loadView()
    view = mainView
  }

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    setup()
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    mainView.textField.endEditing(true)
  }

  private func setup() {
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBar.delegate = self
    mainView.textField.rightView?.isHidden = true
  }

  func bind(reactor: EnterRoomCodeViewReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension EnterRoomCodeViewController {
  private func bindAction(_ reactor: Reactor) {
    mainView.textField.rx.text
      .orEmpty
      .distinctUntilChanged()
      .map { Reactor.Action.enterRoomCode($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.enterRoomButton.rx.tap
      .map { Reactor.Action.tapEnterRoom(reactor.currentState.roomCode) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: Reactor) {
    
    reactor.state.map { $0.roomCode }
      .bind(to: mainView.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isButtonEnable }
      .bind(to: mainView.enterRoomButton.rx.isEnabled)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isErrorMessageHidden }
      .compactMap { $0 }
      .bind(to: mainView.errorLabel.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.state.map { $0.errorMessage }
      .asDriver(onErrorJustReturn: "")
      .drive(mainView.errorLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$presentPopupFlag)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: presentEnterPopupView)
      .disposed(by: disposeBag)

    reactor.pulse(\.$enterRoomFlag)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: enterExistRoom)
      .disposed(by: disposeBag)

    reactor.state.map { $0.error }
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: 400)
      .drive(onNext: errorHandling)
      .disposed(by: disposeBag)
  }
}

extension EnterRoomCodeViewController {

  private func errorHandling(_ statusCode: Int) {

    if statusCode == 403 {
      Toast.show(message: "해당 방의 정원인 16명을 초과했습니다.", controller: self)
    }
  }

  private func presentEnterPopupView(_ flag: Bool) {
    guard let host = reactor?.currentState.roomHostNickname else { return }

    let enterRoomModel = ImagePopUpModel(
      image: .welcome,
      actionText: "참여하기",
      text: host)
    let popUpType = PopUpType.enterRoom(enterRoomModel: enterRoomModel)

    presentPopUp(popUpType) { [weak self] actionType in
      switch actionType {
      case .action:
        self?.dismiss(animated: true) {
          self?.reactor?.enterRoom()
        }
        return
      case .cancel:
        self?.dismiss(animated: true)
      }
    }
  }

  private func enterExistRoom(_ flag: Bool) {
    let tvc = HousTabbarViewController()
    changeRootViewController(to: tvc)
  }
}

extension EnterRoomCodeViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
