//
//  EnterInfoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

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
    setup()
  }

  private func setup() {
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBar.delegate = self
  }

  func bind(reactor: EnterInfoViewReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension EnterInfoViewController {
  private func bindAction(_ reactor: EnterInfoViewReactor) {
    mainView.nicknameTextfield.rx.text
      .orEmpty
      .scan("") { prev, next in
        print("prev : \(prev), next : \(next)")
        /// - Question : 리액터로 넘기고 싶음, 그렇다면 text를 Observable로 넘겨야하나 ?
        if next.count > 3 {
          return prev
        } else {
          return next.replacingOccurrences(of: " ", with: "")
        }
      }
      .map { Reactor.Action.enterNickname($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.datePicker.rx.date
      .skip(1)
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
  }

  private func bindState(_ reactor: EnterInfoViewReactor) {

    reactor.state.map { $0.nickname }
      .asDriver(onErrorJustReturn: "")
      .drive(mainView.nicknameTextfield.rx.text)
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

    reactor.state.map { $0.next }
      .subscribe(onNext: { [weak self] isTapped in
        // 서버통신
        if isTapped {
          let vc = PagingViewController()
          vc.modalTransitionStyle = .crossDissolve
          vc.modalPresentationStyle = .fullScreen
          self?.present(vc, animated: true, completion: nil)
        }
      })
      .disposed(by: disposeBag)
  }
}

extension EnterInfoViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
