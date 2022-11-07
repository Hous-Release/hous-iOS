//
//  ByDayTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/06.
//

import UIKit

import ReactorKit
import Network

final class ByDayTodoViewController: UIViewController, ReactorKit.View {
  typealias Reactor = ByDayTodoViewReactor

  var mainView = ByDayTodoView()
  var disposeBag = DisposeBag()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
    setTabBarIsHidden(isHidden: true)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension ByDayTodoViewController {
  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension ByDayTodoViewController {
  private func bindAction(_ reactor: Reactor) {

  }

  private func bindState(_ reactor: Reactor) {

  }
}
