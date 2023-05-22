//
//  ConfirmRemoveProfileViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/22.
//

import UIKit
import ReactorKit

final class ConfirmRemoveProfileViewController: UIViewController, ReactorKit.View {

  typealias Reactor = ConfirmRemoveProfileReactor
  var disposeBag = DisposeBag()
  var mainView = ConfirmRemoveProfileView()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    self.view.backgroundColor = Colors.white.color
    navigationController?.navigationBar.isHidden = true
    mainView.navigationBarView.delegate = self
  }
}

extension ConfirmRemoveProfileViewController {

  func bind(reactor: Reactor) {
    // bindaction
  }
}

extension ConfirmRemoveProfileViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
