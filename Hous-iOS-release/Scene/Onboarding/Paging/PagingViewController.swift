//
//  PagingViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/23.
//

import UIKit

import RxCocoa
import RxDataSources
import ReactorKit

final class PagingViewController: UIViewController, View {

  private var currentPage = 0 {
    didSet {
      mainView.pageControl.currentPage = currentPage
    }
  }
  var disposeBag = DisposeBag()
  var mainView = PagingView()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor = PagingViewReactor()
  }

  func bind(reactor: PagingViewReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
}

extension PagingViewController {

  private func bindAction(_ reactor: PagingViewReactor) {
    rx.viewWillAppear
      .map { _ in Reactor.Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.pagingCollectionView.rx.didEndDecelerating
      .map { _ in Reactor.Action.didEndScroll(self.currentPage) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.navigationBar.rightButton.rx.tap
      .map { _ in Reactor.Action.skipDidTap }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.nextButton.rx.tap
      .map { _ in Reactor.Action.nextDidTap }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    mainView.pagingCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: PagingViewReactor) {
    reactor.state.map { $0.pagingContents }
      .distinctUntilChanged()
      .bind(to: mainView.pagingCollectionView.rx.items) { (collectionView, row, element) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagingCell.className, for: IndexPath.init(row: row, section: 0)) as? PagingCell else {

          return UICollectionViewCell()
        }
        cell.setCell(content: element)
        return cell
      }
      .disposed(by: disposeBag)

    reactor.state.map { $0.skip }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isTapped in
        self?.goToLastPage(isTapped)
      })
      .disposed(by: disposeBag)

    reactor.state.map { $0.next }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] isTapped in
        if isTapped {
          let nvc = UINavigationController(rootViewController: EnterRoomViewController())
          nvc.modalPresentationStyle = .fullScreen
          nvc.modalTransitionStyle = .crossDissolve
          self?.present(nvc, animated: true, completion: nil)
        }
      })
      .disposed(by: disposeBag)

    reactor.state.map { $0.isNextButtonHidden }
      .distinctUntilChanged()
      .bind(to: mainView.nextButton.rx.isHidden)
      .disposed(by: disposeBag)
  }
}

extension PagingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = scrollView.frame.width
    currentPage = Int(scrollView.contentOffset.x / width)
  }
}

extension PagingViewController {
  private func goToLastPage(_ isTapped: Bool) {
    let lastPage = PagingContent.sampleData.count - 1
    if isTapped && currentPage != lastPage  {
      currentPage = lastPage
      let indexPath = IndexPath(item: currentPage, section: 0)
      mainView.pagingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
  }
}
