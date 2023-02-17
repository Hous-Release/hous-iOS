//
//  ByDayTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/06.
//

import UIKit

import RxDataSources
import ReactorKit
import RxCocoa
import Network
import BottomSheetKit

class ByDayTodoViewController: BaseViewController, ReactorKit.View {
  typealias Reactor = ByDayTodoViewReactor

  var mainView = ByDayTodoView()
  var disposeBag = DisposeBag()

  // cell action
  private let tapTodo = PublishRelay<Int>()
  // popup action
  private let tapDelete = PublishRelay<Int>()

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
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
    bindDaysOfWeekCollectionView()
    bindTodoCollectionView(reactor)
  }
}

extension ByDayTodoViewController {
  private func bindAction(_ reactor: Reactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.fetch }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.daysOfWeekCollectionview.rx.itemSelected
      .map { Reactor.Action.didTapDaysOfWeekCell($0.row) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tapTodo
      .map { Reactor.Action.didTapTodo($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tapDelete
      .map { Reactor.Action.didTapDelete($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: Reactor) {

    reactor.pulse(\.$isLoadingHidden)
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: operateLoadingIsHidden)
      .disposed(by: disposeBag)

    reactor.pulse(\.$selectedDayIndexPathRow)
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] row in
        guard let self = self else { return }
        self.mainView.daysOfWeekCollectionview.selectItem(
          at: IndexPath(row: row, section: 0),
          animated: false,
          scrollPosition: [])
      })
      .disposed(by: disposeBag)

    reactor.pulse(\.$selectedTodoSummary)
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: self.tappedTodo)
      .disposed(by: disposeBag)
  }
}

extension ByDayTodoViewController {
  private func operateLoadingIsHidden(_ isHidden: Bool) {
    isHidden ? self.hideLoading() : self.showLoading()
  }
}

extension ByDayTodoViewController {

  private func bindDaysOfWeekCollectionView() {
    Observable.of(["월", "화", "수", "목", "금", "토", "일"])
      .bind(to: mainView.daysOfWeekCollectionview.rx.items) {
        (collectionView, row, item) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaysOfWeekCollectionViewCell.className, for: IndexPath(row: row, section: 0)) as? DaysOfWeekCollectionViewCell else { return UICollectionViewCell() }

        cell.setCell(item)
        return cell
      }
      .disposed(by: disposeBag)
  }

  private func bindTodoCollectionView(_ reactor: Reactor) {

    // MARK: -
    mainView.todoCollectionView.rx.setDelegate(self)
        .disposed(by: disposeBag)

    // MARK: - Cell
    let todoDataSource = RxCollectionViewSectionedReloadDataSource<MyOurTodoSection.Model> (configureCell: { dataSource, collectionView, indexPath, item in

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
        cell.setCell(todos.todoName, todos.todoId)
        cell.delegate = self
        return cell

      case .myTodoEmpty:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTodoByDayCollectionViewCell.className, for: indexPath) as? EmptyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(.myTodo)
        return cell

      case let .ourTodo(todos):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OurTodoByDayCollectionViewCell.className, for: indexPath) as? OurTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(todos.todoName, todos.todoId, todos.nicknames)
        cell.delegate = self
        return cell

      case .ourTodoEmpty:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTodoByDayCollectionViewCell.className, for: indexPath) as? EmptyTodoByDayCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(.ourTodo)
        return cell

      default:
        return UICollectionViewCell()
      }
    })

    // MARK: - Header & Footer
    todoDataSource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in

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

    reactor.state.map { [$0.countTodoSection,
                         $0.myTodosByDaySection, $0.myTodosEmptySection,
                         $0.ourTodosByDaySection, $0.ourTodosEmptySection] }
      .distinctUntilChanged()
      .bind(to: self.mainView.todoCollectionView.rx.items(dataSource: todoDataSource))
      .disposed(by: disposeBag)
  }
}

extension ByDayTodoViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 4 {
      return CGSize(width: UIScreen.main.bounds.width, height: 54)
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0 || section == 2 || section == 4 {
      return .zero
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 48)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    if section == 0 || section == 1 || section == 3 {
      return .zero
    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
  }
}

extension ByDayTodoViewController: DidTapMyTodoByDayDelegate {
  func didTapMyTodo(todoId: Int) {
    tapTodo.accept(todoId)
  }
}

extension ByDayTodoViewController: DidTapOurTodoByDayDelegate {

  func didTapOurTodo(todoId: Int) {
    tapTodo.accept(todoId)
  }
}

extension ByDayTodoViewController {
  private func tappedTodo(_ model: TodoModel?) {
    guard let model = model else { return }

    presentBottomSheet(.todoType(model)) { [weak self] actionType in

      guard let self = self,
            let todoId = self.reactor?.currentState.selectedTodoId else { return }

      switch actionType {

      case .modify:
        self.presentModifyTodoBottomSheet(of: todoId)

      case .delete:
        self.presentedViewController?.dismiss(animated: true) {
          self.presentDeletePopup(of: todoId)
        }

      default:
        break
      }
    }
  }

  private func presentModifyTodoBottomSheet(of todoId: Int) {
    reactor?.action.onNext(.initial)

    let provider = ServiceProvider()
    let updateReactor = UpdateTodoReactor(
      provider: provider,
      state: .init(
        id: todoId,
        isModifying: true,
        todoHomies: []
      )
    )
    let updateTodoVC = UpdateTodoViewController(updateReactor)
    self.navigationController?.pushViewController(updateTodoVC, animated: true)
  }

  private func presentDeletePopup(of todoId: Int) {
    presentPopUp(.defaultPopUp(
      defaultPopUpModel: DefaultPopUpModel(
        cancelText: "취소하기",
        actionText: "삭제하기",
        title: "안녕, to-do...",
        subtitle: "to-do는 한 번 삭제하면 복구되지 않아요."
      )
    )) { [weak self] actionType in

      guard let self = self else { return }

      switch actionType {
      case .action:
        self.tapDelete.accept(todoId)
      default:
        break
      }

    }
  }
}
