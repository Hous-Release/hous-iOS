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

//MARK: - Controller
final class TodoViewController: UIViewController, View {
  typealias Reactor = TodoViewReactor

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
    reactor = TodoViewReactor()
    navigationController?.navigationBar.isHidden = true
  }

  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
    bindCollectionView(reactor)
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
      .withUnretained(self)
      .subscribe(onNext: { owner, flag in
        if flag == true {
          owner.navigationController?.pushViewController(FilteredTodoViewController(), animated: true)
        }
      })
      .disposed(by: disposeBag)
  }
}

extension TodoViewController {

  private func bindCollectionView(_ reactor: Reactor) {

    mainView.todoCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    // MARK: - Cell
    let dataSource = RxCollectionViewSectionedReloadDataSource<TodoMainSection.Model> (configureCell: { dataSource, collectionView, indexPath, item in
      switch item {
      case .myTodo(let todos):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTodoCollectionViewCell.className, for: indexPath) as? MyTodoCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.cellCheckSubject
          .map { _ in Reactor.Action.fetch }
          .bind(to: reactor.action)
          .disposed(by: cell.disposeBag)
        cell.setCell(todos.todoId, todos.isChecked, todos.todoName)
        return cell

      case .myTodoEmpty:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTodoByDayCollectionViewCell.className, for: indexPath) as? EmptyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(.myTodo)
        return cell

      case .ourTodo(let todos):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OurTodoCollectionViewCell.className, for: indexPath) as? OurTodoCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(todos.status, todos.todoName)
        return cell

      case .ourTodoEmpty:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTodoByDayCollectionViewCell.className, for: indexPath) as? EmptyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(.ourTodo)
        return cell
      }
    })

    // MARK: - Header & Footer
    dataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in

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

  private func getHeaderYOffset(_ indexPath: IndexPath) -> CGFloat {

    let attributes = self.mainView.todoCollectionView.layoutAttributesForItem(at: indexPath)
    let point = self.mainView.todoCollectionView.frame.origin.y
    let offset = self.mainView.todoCollectionView.contentOffset.y
    return (attributes?.center.y)! + point - offset
  }
}

extension TodoViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 1 || indexPath.section == 3 {
      return CGSize(width: UIScreen.main.bounds.width, height: 60)
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 1 || section == 3 {
      return .zero
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 48)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if section == 0 || section == 2 {
      return .zero
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
  }
}
