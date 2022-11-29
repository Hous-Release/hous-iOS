//
//  MemberTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/22.
//

import UIKit

import ReactorKit
import RxDataSources
import RxCocoa
import Network
import BottomSheetKit

final class MemberTodoViewController: UIViewController, ReactorKit.View {
  typealias Reactor = MemberTodoViewReactor

  var mainView = MemberTodoView()
  var disposeBag = DisposeBag()

  var dataSource: UICollectionViewDiffableDataSource<TodoByMemSection, TodoByMemListItem>!

  // cell action
  private let tapTodo = PublishRelay<Int>()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
    makeDataSource()
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
  func bind(reactor: Reactor) {
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

    tapTodo
      .map { Reactor.Action.didTapTodo($0) }
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
        if indexPath.row == 0 {
          collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        return cell
      }
    }

    reactor.pulse(\.$selectedMemIndexPathRow)
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] row in
        guard let self = self else { return }
        self.mainView.memberCollectionView.selectItem(
          at: IndexPath(row: row, section: 0),
          animated: false,
          scrollPosition: [])
      })
      .disposed(by: disposeBag)

    reactor.state.map { [$0.membersSection] }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(self.mainView.memberCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    reactor.state.map { $0.selectedMember }
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: self.setupSnapshot)
      .disposed(by: disposeBag)

    reactor.pulse(\.$selectedTodoSummary)
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: self.tappedTodo)
      .disposed(by: disposeBag)
  }
}

extension MemberTodoViewController {
  // MARK: - Initialize data source
  private func makeDataSource() {

    let totalNumCell = totalNumCellRegistration()
    let headerCell = headerCellRegistration()
    let todoCell = todoCellRegistration()
    let emptyCell = emptyCellRegistration()

    dataSource = UICollectionViewDiffableDataSource<TodoByMemSection, TodoByMemListItem>(collectionView: mainView.todoCollectionView) {
      (collectionView, indexPath, todoByMemItem) -> UICollectionViewCell? in

      switch todoByMemItem {
      case .totalNum(let todoNum):
        let cell = collectionView.dequeueConfiguredReusableCell(
          using: totalNumCell,
          for: indexPath,
          item: todoNum)
        cell.isUserInteractionEnabled = false
        return cell

      case .header(let headerItem):
        let cell = collectionView.dequeueConfiguredReusableCell(
          using: headerCell,
          for: indexPath,
          item: headerItem)
        // header background color & corner radius
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = Colors.g1.color
        backgroundConfig.cornerRadius = 8
        backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        cell.backgroundConfiguration = backgroundConfig
        cell.tintColor = Colors.g4.color
        return cell

      case .todo(let todolItem):
        let cell = collectionView.dequeueConfiguredReusableCell(
          using: todoCell,
          for: indexPath,
          item: todolItem)
        cell.delegate = self
        return cell

      case .empty(let guideText):
        let cell = collectionView.dequeueConfiguredReusableCell(
          using: emptyCell,
          for: indexPath,
          item: guideText)
        cell.isUserInteractionEnabled = false
        return cell
      }
    }
  }
  // MARK: - Setup snapshots
  private func setupSnapshot(_ memTodo: MemberTodoModel?) {
    guard let memTodo = memTodo else { return }

    var dataSourceSnapshot = NSDiffableDataSourceSnapshot<TodoByMemSection, TodoByMemListItem>()
    // Datasource snapshot에 section 추가
    dataSourceSnapshot.appendSections([.main, .totalNum])
    dataSource.apply(dataSourceSnapshot)

    // section snapshot 생성
    var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<TodoByMemListItem>()

    // totalNum CELL
    let totalNum = memTodo.totalTodoCnt
    let totalNumItem = TodoByMemListItem.totalNum(totalNum)
    sectionSnapshot.append([totalNumItem])
    dataSource.apply(sectionSnapshot, to: .totalNum, animatingDifferences: false)

    if totalNum != 0 {
      // header(요일) CELL + child(todo) CELL
      for headerItem in memTodo.dayOfWeekTodos {

        // 헤더 리스트 아이템 생성 후 header로 추가
        let headerListItem = TodoByMemListItem.header(headerItem)
        sectionSnapshot.append([headerListItem])
        // 투두 리스트 아이템 생성 후 child로 추가
        let todoListItemArray = headerItem.dayOfWeekTodos.map { TodoByMemListItem.todo($0) }
        sectionSnapshot.append(todoListItemArray, to: headerListItem)
        // Expand
        sectionSnapshot.expand([headerListItem])
      }
      dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    } else {
      let emptyItem = TodoByMemListItem.empty("아직 담당하는 to-do가 없어요!")
      sectionSnapshot.append([emptyItem])
      dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
  }
}

// MARK: - Cell registration
extension MemberTodoViewController {

  private func totalNumCellRegistration() -> UICollectionView.CellRegistration<TotalTodoNumListCell, Int> {
    let totalNumCellRegistration = UICollectionView.CellRegistration<TotalTodoNumListCell, Int> {
      (cell, indexPath, totalNum) in
      cell.update(with: totalNum)
    }
    return totalNumCellRegistration
  }

  private func headerCellRegistration() -> UICollectionView.CellRegistration<DayOfWeekHeaderListCell, DayOfWeekTodoModel>  {
    let headerCellRegistration = UICollectionView.CellRegistration<DayOfWeekHeaderListCell, DayOfWeekTodoModel> {
      (cell, indexPath, headerItem) in

      cell.update(with: headerItem)
      // disclosure accessory
      let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
      cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
    }
    return headerCellRegistration
  }

  private func todoCellRegistration() -> UICollectionView.CellRegistration<TodoByMemListCell, TodoInfoWithIdModel> {
    let todoCellRegistration = UICollectionView.CellRegistration<TodoByMemListCell, TodoInfoWithIdModel> {
      (cell, indexPath, todoItem) in
      cell.update(with: todoItem)
    }
    return todoCellRegistration
  }

  private func emptyCellRegistration() -> UICollectionView.CellRegistration<MemEmptyListCell, String> {
    let emptyCellRegistration = UICollectionView.CellRegistration<MemEmptyListCell, String> {
      (cell, indexPath, emptyItem) in
      cell.update(with: emptyItem)
    }
    return emptyCellRegistration
  }
}

extension MemberTodoViewController: DidTapMemTodoDelegate {
  func didTapTodo(todoId: Int) {
    tapTodo.accept(todoId)
  }
}

extension MemberTodoViewController {
  private func tappedTodo(_ model: TodoModel?) {
    guard let model = model else { return }

    presentBottomSheet(.todoType(model))
  }
}
