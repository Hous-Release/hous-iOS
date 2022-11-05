//
//  EnterRoomCodeViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/27.
//

import UIKit
import RxCocoa
import ReactorKit

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

    reactor.state.map { $0.viewTransition }
      .compactMap { $0 }
      .withUnretained(self)
      .subscribe(onNext: { owner, isTapped in
        if isTapped {
          // 뷰전환
          print("✨팝업팝업팝업팝업팝업✨")
          reactor.action.onNext(.initial)
        }
      })
      .disposed(by: disposeBag)
  }
}

extension EnterRoomCodeViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTappedWithoutPopUp() {
    print("back")
  }
  
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
