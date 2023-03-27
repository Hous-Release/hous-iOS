//
//  TodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/07.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

// MARK: - Controller
final class TodoViewController: BaseViewController, View, LoadingPresentable {
  typealias Reactor = TodoViewReactor

  private enum Size {
    static let todoItemHeight: CGFloat = 30
    static let emptyItemHeight: CGFloat = 60
    static let headerItemHeight: CGFloat = 48
    static let footerItmeHeight: CGFloat = 40
  }

  var disposeBag = DisposeBag()
  var mainView = TodoView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: false)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let serviceProvider = ServiceProvider()
    reactor = TodoViewReactor(provider: serviceProvider)
    navigationController?.navigationBar.isHidden = true
  }

  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindCollectionView(reactor)
    bindState(reactor)
  }
}

extension TodoViewController {
  private func bindAction(_ reactor: Reactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.fetch }
      .bind(to: reactor.action)
        .disposed(by: disposeBag)

        mainView.viewAllButton.rx.tap
        .map { _ in Reactor.Action.didTapViewAll }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: Reactor) {

    reactor.pulse(\.$isLoadingHidden)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: operateLoadingIsHidden)
      .disposed(by: disposeBag)

    reactor.state.map { $0.date }
      .bind(to: mainView.dateLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.dayOfWeek }
      .bind(to: mainView.dayOfWeekLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$isTodoEmpty)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: true)
      .drive(mainView.progressBarView.rx.isTodoEmpty)
      .disposed(by: disposeBag)

    reactor.pulse(\.$progressType)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: .none)
      .drive(mainView.progressBarView.rx.progressType)
      .disposed(by: disposeBag)

    reactor.pulse(\.$progress)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: 0)
      .drive(mainView.progressBarView.rx.progress)
      .disposed(by: disposeBag)

    reactor.pulse(\.$enterViewAllFlag)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: transferViewAllTodo)
      .disposed(by: disposeBag)
  }
}

extension TodoViewController {
  private func transferViewAllTodo(_ flag: Bool) {
    navigationController?.pushViewController(FilteredTodoViewController(), animated: true)
    // self.reactor?.action.onNext(.initial)
  }
}

extension TodoViewController {
  private func operateLoadingIsHidden(_ isHidden: Bool) {
    if isHidden { self.hideLoading() } else { self.showLoading() }
  }
}

extension TodoViewController {

  private func bindCollectionView(_ reactor: Reactor) {

    mainView.todoCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    // MARK: - Cell
    let dataSource = RxCollectionViewSectionedReloadDataSource<TodoMainSection.Model>(
      configureCell: { _, collectionView, indexPath, item in
      switch item {
      case .myTodo(let todos):
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MyTodoCollectionViewCell.className,
          for: indexPath) as? MyTodoCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.cellCheckSubject
          .map { _ in Reactor.Action.fetch }
          .bind(to: reactor.action)
          .disposed(by: cell.disposeBag)
        cell.setCell(todos.todoId, todos.isChecked, todos.todoName)
        return cell

      case .myTodoEmpty:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: EmptyTodoByDayCollectionViewCell.className,
          for: indexPath) as? EmptyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(.myTodo)
        return cell

      case .ourTodo(let todos):
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: OurTodoCollectionViewCell.className,
          for: indexPath) as? OurTodoCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(todos.status, todos.todoName, todos.nicknames)
        return cell

      case .ourTodoEmpty:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: EmptyTodoByDayCollectionViewCell.className,
          for: indexPath) as? EmptyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(.ourTodo)
        return cell
      }
    })

    // MARK: - Header & Footer
    dataSource.configureSupplementaryView = {
      (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in

      switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard let header = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: TodoHeaderCollectionReusableView.className,
          for: indexPath) as? TodoHeaderCollectionReusableView else {
          return UICollectionReusableView()
        }

        switch dataSource.sectionModels[indexPath.section].model {
        case .myTodo(let num):
          header.setHeader(.myTodo, num)
        case .myTodoEmpty:
          header.setHeader(.myTodo, 0)
        case .ourTodo(let num):
          header.setHeader(.ourTodo, num)
        case .ourTodoEmpty:
          header.setHeader(.ourTodo, 0)
        }

        // ourtodo 관련 header 일 때만 버튼 action 활성화
        if indexPath.section >= 2 {
          self.bindHeaderGuideButton(header, at: indexPath)
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

    reactor.state.map { [$0.myTodosSection, $0.myTodosEmptySection, $0.ourTodosSection, $0.ourTodosEmptySection] }
      .bind(to: self.mainView.todoCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

extension TodoViewController {

  private func bindHeaderGuideButton(_ header: TodoHeaderCollectionReusableView, at indexPath: IndexPath) {
    header.infoButton.rx.tap
      .subscribe { [weak self] _ in

        let popupViewController = TodoPopupViewController()
        popupViewController.modalTransitionStyle = .crossDissolve
        popupViewController.modalPresentationStyle = .overFullScreen

        let headerYOffset = self?.getHeaderYOffset(indexPath)

        popupViewController.mainView.buttonPoint =
        CGPoint(
          x: header.infoButton.center.x,
          y: headerYOffset! + header.infoButton.center.y)
        self?.present(popupViewController, animated: true)
      }
      .disposed(by: header.disposeBag)
  }

  private func getHeaderYOffset(_ indexPath: IndexPath) -> CGFloat {

    let attributes = self.mainView.todoCollectionView.layoutAttributesForItem(at: indexPath)
    let point = self.mainView.todoCollectionView.frame.origin.y
    let scrollOffset = self.mainView.todoCollectionView.contentOffset.y
    let attributesCenter = attributes?.center ?? CGPoint(x: 0, y: 0)
    let currentTodoCount = reactor?.currentState.ourTodosSection.items.count
    // print("point: \(point), scrollOffset : \(scrollOffset), attributesCenter: \(attributesCenter.y)")
    let boxOffset = attributesCenter.y + point - scrollOffset
    return currentTodoCount == 0 ? boxOffset - 15 : boxOffset
  }
}

extension TodoViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {

    if indexPath.section == 1 || indexPath.section == 3 {
      return CGSize(width: UIScreen.main.bounds.width, height: Size.emptyItemHeight)
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: Size.todoItemHeight)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int) -> CGSize {

    let headerSize = CGSize(width: UIScreen.main.bounds.width, height: Size.headerItemHeight)
    // ourTodo 개수 0일 땐 empty header 사용
    if reactor?.currentState.ourTodosSection.items.count == 0 {

      return (section == 1 || section == 3) ? headerSize : .zero

    } else {

      return (section == 1 || section == 3) ? .zero : headerSize

    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int) -> CGSize {
    if section == 0 || section == 2 {
      return .zero
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: Size.footerItmeHeight)
    }
  }
}
