//
//  ResignViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit
import ReactorKit
import RxCocoa
import RxGesture

class ResignViewController: UIViewController, ReactorKit.View {
  typealias Reactor = ResignViewReactor

  var disposeBag = DisposeBag()
  var mainView = ResignView()

  private var coveredByKeyboardHeight: CGFloat = 0

  private let tapCheckButton = PublishRelay<Void>()
  private let tapResignButton = PublishRelay<Void>()
  private let selectResignReason = PublishRelay<String?>()

  override func loadView() {
    super.loadView()
    view = mainView
  }

  init(_ reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
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
    mainView.collectionView.delegate = self
    mainView.collectionView.dataSource = self
    mainView.navigationBarView.delegate = self
    setKeyboardObserver()
  }

  private func setKeyboardObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification, object:nil)
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.window?.frame.origin.y != 0 {
      self.view.window?.frame.origin.y = 0
    }
  }
}

extension ResignViewController {
  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
  }

  private func bindAction(_ reactor: Reactor) {
    tapCheckButton
      .map { Reactor.Action.didTapCheck }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tapResignButton
      .map { Reactor.Action.didTapResign }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    selectResignReason
      .map { Reactor.Action.didSelectResignReason($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindState(_ reactor: Reactor) {

  }
}

extension ResignViewController {

}

extension ResignViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if indexPath.section == 0 {
      guard let guideCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ResignGuideCollectionViewCell.className,
        for: indexPath
      ) as? ResignGuideCollectionViewCell else { return UICollectionViewCell() }

      return guideCell

    } else {

      guard let inputCell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ResignInputCollectionViewCell.className,
        for: indexPath
      ) as? ResignInputCollectionViewCell else { return UICollectionViewCell() }

      inputCell.delegate = self

      // MARK: - inputCell input
      inputCell.resignCheckButton.rx.tap
        .asDriver()
        .drive(onNext: { [weak self] in
          guard let self = self else { return }
          self.tapCheckButton.accept($0)
          inputCell.resignCheckButton.isSelected = !inputCell.resignCheckButton.isSelected
        })
        .disposed(by: disposeBag)

      inputCell.resignButton.rx.tap
        .bind(to: tapResignButton)
        .disposed(by: disposeBag)

      inputCell.reasonTextField.rx.text
        .distinctUntilChanged()
        .bind(to: selectResignReason)
        .disposed(by: disposeBag)

      return inputCell
    }
  }
}

extension ResignViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    if indexPath.section == 0 {
      return CGSize(width: UIScreen.main.bounds.width, height: 416)

    } else {
      return CGSize(width: UIScreen.main.bounds.width, height: 350)
      // 레퍼런스 참고해서 텍스트뷰 delegate 에서 높이 조정하기
    }
  }
}

extension ResignViewController: ResignInputCellDelegate {
  func didTapTextField() {

    coveredByKeyboardHeight = calculateTextFieldHeight()
    let keyboardStart = UIScreen.main.bounds.height - 216
    UIView.animate(withDuration: 1) {
      self.view.window?.frame.origin.y -= (self.coveredByKeyboardHeight - keyboardStart)
    }
  }

  func didTapTextView() {
    // 텍스트뷰 위치도 고려해야하고 windo frame 도 고려해야함
    coveredByKeyboardHeight = calculateTextFieldHeight()
    let keyboardStart = UIScreen.main.bounds.height - 216
    UIView.animate(withDuration: 1) {
      self.view.window?.frame.origin.y -= (self.coveredByKeyboardHeight - keyboardStart)
    }
  }

  private func calculateTextFieldHeight() -> CGFloat {
    let attributes = self.mainView.collectionView.layoutAttributesForItem(
      at: IndexPath(row: 0, section: 1)
    )
    let cellCenterPoint = attributes?.center.y ?? 0
    let collectionViewPoint = self.mainView.collectionView.frame.origin.y
    let scrollOffset = self.mainView.collectionView.contentOffset.y
    let coveredByKeyboardHeight = cellCenterPoint + collectionViewPoint - scrollOffset

    print("attributescenter: \(cellCenterPoint), point: \(collectionViewPoint), scrollOffset: \(scrollOffset), offset: \(coveredByKeyboardHeight)")

    return coveredByKeyboardHeight
  }


}

extension ResignViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
