//
//  ProfileLeaveViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/12.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources

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
    mainView.navigationBarView.delegate = self
    //setTabBarIsHidden(isHidden: true)
  }

  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
    bindCollectionView(reactor)
  }
}

extension ProfileLeaveViewController {
  private func bindAction(_ reactor: Reactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.fetch }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.leaveButton.rx.tap
      .map { Reactor.Action.didTapLeaveRoom }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindCollectionView(_ reactor: Reactor) {

    mainView.collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    // MARK: - Cell
    let dataSource = RxCollectionViewSectionedReloadDataSource<OnlyMyTodoSection.Model> (configureCell: { dataSource, collectionView, indexPath, item in

      switch item {
      case .guide:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileLeaveGuideCollectionViewCell.className, for: indexPath) as? ProfileLeaveGuideCollectionViewCell else {
          return UICollectionViewCell()
        }
        return cell

      case let .countTodo(num):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountTodoByDayCollectionViewCell.className, for: indexPath) as? CountTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(num)
        return cell

      case let .myTodo(todos):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTodoByDayCollectionViewCell.className, for: indexPath) as? MyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCellWithDayOfWeek(todos.todoName, todos.dayOfWeeks)
        return cell

      case .myTodoEmpty:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTodoByDayCollectionViewCell.className, for: indexPath) as? EmptyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(.myTodo)
        return cell
      }
    })

    // MARK: - Header & Footer
    dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in

      switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: ByDayHeaderCollectionReusableView.className,
          for: indexPath) as? ByDayHeaderCollectionReusableView else {
          return UICollectionReusableView()
        }
        return header

      case UICollectionView.elementKindSectionFooter:
        guard let footer = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: TodoFooterCollectionReusableView.className,
          for: indexPath) as? TodoFooterCollectionReusableView else {
          return UICollectionReusableView()
        }
        return footer

      default:
        return UICollectionReusableView()
      }
    }

    reactor.state.map { [$0.guideSection, $0.countTodoSection,
                         $0.myTodoSection, $0.myTodoEmptySection] }
    .distinctUntilChanged()
    .bind(to: self.mainView.collectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: Reactor) {

    reactor.pulse(\.$isLeaveRoomSuccess)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: transferToEnterRoom)
      .disposed(by: disposeBag)
  }

}

extension ProfileLeaveViewController {

  private func transferToEnterRoom(_ isSuccess: Bool) {
    if isSuccess {
      let enterRoomVC = EnterRoomViewController()
      changeRootViewController(to: UINavigationController(rootViewController: enterRoomVC))
    }
  }

}

extension ProfileLeaveViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 0 {
      return CGSize(width: UIScreen.main.bounds.width, height: 394)
    } else if indexPath.section == 2 {
      return CGSize(width: UIScreen.main.bounds.width, height: 30)
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 54)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 2 {
      return CGSize(width: UIScreen.main.bounds.width, height: 48)
    } else {
      return .zero
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if section == 3 {
      return CGSize(width: UIScreen.main.bounds.width, height: 143)
    } else {
      return .zero
    }
  }
}

extension ProfileLeaveViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
