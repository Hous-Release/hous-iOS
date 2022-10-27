//
//  MemberTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/22.
//

import UIKit

import ReactorKit
import RxDataSources

class MemberTodoViewController: UIViewController, ReactorKit.View {
  typealias Reactor = MemberTodoViewReactor

  var mainView = MemberTodoView()
  var disposeBag = DisposeBag()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}

extension MemberTodoViewController {
  func bind(reactor: MemberTodoViewReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension MemberTodoViewController {
  private func bindAction(_ reactor: Reactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.fetch }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: Reactor) {

    let dataSource = RxCollectionViewSectionedReloadDataSource<MemberSection.Model> { dataSource, collectionView, indexPath, item in
      switch item {
      case .members(let member):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.className, for: indexPath) as? MemberCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.bind(reactor: MemberCollectionViewCellReactor(state: member))
        return cell
      }
    }

    reactor.state.map { [$0.membersSection] }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(self.mainView.memberCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

}
