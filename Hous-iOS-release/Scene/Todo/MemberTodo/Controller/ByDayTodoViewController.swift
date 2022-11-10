//
//  ByDayTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/06.
//

import UIKit

import RxDataSources
import ReactorKit
import Network

class ByDayTodoViewController: UIViewController, ReactorKit.View {
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
    bindCollectionView(reactor)
  }
}

extension ByDayTodoViewController {
  private func bindAction(_ reactor: Reactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.fetch }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: Reactor) {

  }
}

extension ByDayTodoViewController {
  private func bindCollectionView(_ reactor: Reactor) {

    // MARK: -
    mainView.todoCollectionView.rx.setDelegate(self)
        .disposed(by: disposeBag)

    // MARK: - Cell
    let dataSource = RxCollectionViewSectionedReloadDataSource<ByDayTodoSection.Model> (configureCell: { dataSource, collectionView, indexPath, item in
      switch item {
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
        cell.setCell(todos.todoName)
        return cell
      case let .ourTodo(todos):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OurTodoByDayCollectionViewCell.className, for: indexPath) as? OurTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(todos.todoName, todos.nicknames)
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
        header.setHeader(dataSource.sectionModels[indexPath.section].model)
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

    reactor.state.map { [$0.countTodoSection, $0.myTodosByDaySection, $0.ourTodosByDaySection] }
      .distinctUntilChanged()
      .bind(to: self.mainView.todoCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

extension ByDayTodoViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 0 {
      return CGSize(width: UIScreen.main.bounds.width, height: 54)
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0 {
      return .zero
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 48)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if section == 0 {
      return .zero
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
  }
}
