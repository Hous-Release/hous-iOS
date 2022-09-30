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

  var disposeBag = DisposeBag()
  var mainView = TodoView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor = TodoViewReactor()
    navigationController?.navigationBar.isHidden = true
  }

  func bind(reactor: TodoViewReactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.fetch }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.state.map { $0.date }
      .bind(to: mainView.dateLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.dayOfWeek }
      .bind(to: mainView.dayOfWeekLabel.rx.text)
      .disposed(by: disposeBag)

    reactor.state.map { $0.progressType }
      .skip(1)
      .bind(to: mainView.progressBarView.rx.progressType)
      .disposed(by: disposeBag)

    reactor.state.map {$0.progress}
      .subscribe(onNext: { progress in
        self.mainView.progressBarView.progressView.progress = progress
        self.mainView.progressBarView.progress = progress
      })
      .disposed(by: disposeBag)

    bindCollectionView(reactor)
  }
}

extension TodoViewController {
  private func bindCollectionView(_ reactor: TodoViewReactor) {

    let dataSource = RxCollectionViewSectionedReloadDataSource<TodoMainSection.Model> (configureCell: { dataSource, collectionView, indexPath, item in
      switch item {
      case .myTodo(let todos):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTodoCollectionViewCell.className, for: indexPath) as? MyTodoCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(todos.isChecked, todos.todoName)
        return cell

      case .ourTodo(let todos):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OurTodoCollectionViewCell.className, for: indexPath) as? OurTodoCollectionViewCell else {
          return UICollectionViewCell()
        }
        cell.setCell(todos.status, todos.todoName)
        return cell
      }
    })

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
        case .ourTodo(let num):
          header.setHeader(.ourTodo, num)
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

    reactor.state.map { [$0.myTodosSection, $0.ourTodosSection] }
      .distinctUntilChanged()
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
