//
//  ProfileLeaveViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/12.
//

import UIKit
import ReactorKit
import RxCocoa
import RxGesture

class ProfileLeaveViewController: UIViewController, ReactorKit.View {
  typealias Reactor = ProfileLeaveViewReactor

  var disposeBag = DisposeBag()
  var mainView = ProfileLeaveView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    navigationController?.navigationBar.isHidden = true
  }

  func bind(reactor: Reactor) {
    
  }
}

extension ProfileLeaveViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
