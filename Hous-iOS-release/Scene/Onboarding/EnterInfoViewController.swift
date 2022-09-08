//
//  EnterInfoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

class EnterInfoViewController: UIViewController, View {

  var disposeBag = DisposeBag()
  let mainView = EnterInfoView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor = EnterInfoViewReactor()
  }

  func bind(reactor: EnterInfoViewReactor) {
    mainView.nicknameTextfield.rx.text
      .orEmpty
      .distinctUntilChanged()
      .map { Reactor.Action.enterNickname($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.datePicker.rx.date
      .map { Reactor.Action.enterBirthday($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.checkBirthDayButton.rx.tap
      .map { Reactor.Action.checkBirthdayPublic(
        self.mainView.checkBirthDayButton.isSelected) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.nextButton.rx.tap
      .map { Reactor.Action.tapNext }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isBirthdayPublic }
      .bind(to: mainView.checkBirthDayButton.rx.isSelected)
      .disposed(by: disposeBag)

    reactor.state.map { $0.birthday }
      .bind(to: mainView.birthdayTextfield.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.isNextButtonEnable }
      .bind(to: mainView.nextButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}
