//
//  MemberTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/22.
//

import UIKit

import ReactorKit
import RxDataSources
import Network
import AssetKit

public typealias MemberHeaderItem = MemberTodoDTO.Response.DayOfWeekTodo
public typealias MemebrTodoItem = MemberTodoDTO.Response.TodoInfo

class MemberTodoViewController: UIViewController, ReactorKit.View {
  typealias Reactor = MemberTodoViewReactor

  var mainView = MemberTodoView()
  var disposeBag = DisposeBag()

  var dataSource: UICollectionViewDiffableDataSource<MemberHeaderItem, TodoByMemListItem>!

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
    makeDataSource()
    if let tvc = navigationController?.tabBarController as? HousTabbarViewController {
      tvc.housTabBar.isHidden = true
    }
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

    mainView.memberCollectionView.rx.itemSelected
      .map { Reactor.Action.didTapMemberCell($0.row) }
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

    reactor.state.map { $0.selectedMember }
      .distinctUntilChanged()
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: self.setupSnapshot)
      .disposed(by: disposeBag)
  }
}

extension MemberTodoViewController {
  // MARK: Initialize data source
  private func makeDataSource() {

    let headerCell = headerCellRegistration()
    let todoCell = todoCellRegistration()

    dataSource = UICollectionViewDiffableDataSource<MemberHeaderItem, TodoByMemListItem>(collectionView: mainView.todoCollectionView) {
      (collectionView, indexPath, todoByMemItem) -> UICollectionViewCell? in

      switch todoByMemItem {
      case .header(let headerItem):
        // 디큐 헤더 셀
        let cell = collectionView.dequeueConfiguredReusableCell(
          using: headerCell,
          for: indexPath,
          item: headerItem)
        // header background color & corner radius
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = Colors.g1.color
        backgroundConfig.cornerRadius = 8
        cell.backgroundConfiguration = backgroundConfig
        cell.tintColor = Colors.g4.color
        return cell

      case .todo(let todolItem):
        // 디큐 투두 셀
        let cell = collectionView.dequeueConfiguredReusableCell(
          using: todoCell,
          for: indexPath,
          item: todolItem)
        return cell
      }
    }
  }

  private func setupSnapshot(_ firstMemTodo: [MemberHeaderItem]) {
    // MARK: Setup snapshots
    var dataSourceSnapshot = NSDiffableDataSourceSnapshot<MemberHeaderItem, TodoByMemListItem>()

    // Datasource snapshot에 section 추가
    dataSourceSnapshot.appendSections(firstMemTodo)
    dataSource.apply(dataSourceSnapshot)

    for headerItem in firstMemTodo {

      // section snapshot 생성
      var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<TodoByMemListItem>()
      // 헤더 리스트 아이템 생성 후 header로 추가
      let headerListItem = TodoByMemListItem.header(headerItem)
      sectionSnapshot.append([headerListItem])
      // 투두 리스트 아이템 생성 후 child로 추가
      let todoListItemArray = headerItem.dayOfWeekTodos.map { TodoByMemListItem.todo($0) }
      sectionSnapshot.append(todoListItemArray, to: headerListItem)
      // Expand
      sectionSnapshot.expand([headerListItem])
      // main Section에 sectionSnapshot apply
      dataSource.apply(sectionSnapshot, to: headerItem, animatingDifferences: false)
    }
  }
}

extension MemberTodoViewController {
  private func headerCellRegistration() -> UICollectionView.CellRegistration<DayOfWeekHeaderListCell, MemberHeaderItem>  {
    // MARK: Cell registration
    let headerCellRegistration = UICollectionView.CellRegistration<DayOfWeekHeaderListCell, MemberHeaderItem> {
      (cell, indexPath, headerItem) in

      cell.update(with: headerItem)
      // disclosure accessory
      let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
      cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
    }
    return headerCellRegistration
  }

  private func todoCellRegistration() -> UICollectionView.CellRegistration<TodoByMemListCell, MemebrTodoItem> {
    let todoCellRegistration = UICollectionView.CellRegistration<TodoByMemListCell, MemebrTodoItem> {
      (cell, indexPath, todoItem) in
      cell.update(with: todoItem)
    }
    return todoCellRegistration
  }
}
