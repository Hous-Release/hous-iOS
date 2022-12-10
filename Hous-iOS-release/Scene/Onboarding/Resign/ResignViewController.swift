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

  private var textViewHeight: CGFloat = 62
  private var coveredByKeyboardHeight: CGFloat = 0
  private let keyboardStart = UIScreen.main.bounds.height - 260

  private let tapCheckButton = PublishRelay<Void>()
  private let tapResignButton = PublishRelay<Void>()
  private let selectResignReason = PublishRelay<String?>()
  private let enterDetailReason = PublishRelay<String?>()

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
      name: UIResponder.keyboardWillHideNotification,
      object:nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
  }

  @objc func keyboardWillShow(notification: NSNotification) {

    if let keyboardFrame: NSValue =
        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height

      UIView.animate(withDuration: 1) {
        self.scrollToBottom()
        self.view.window?.frame.origin.y -= keyboardHeight
      }
    }
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

    enterDetailReason
      .map { Reactor.Action.enterDetailReason($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
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
        .bind(to: tapCheckButton)
        .disposed(by: disposeBag)

      inputCell.resignButton.rx.tap
        .bind(to: tapResignButton)
        .disposed(by: disposeBag)

      inputCell.reasonTextField.rx.text
        .distinctUntilChanged()
        .bind(to: selectResignReason)
        .disposed(by: disposeBag)

      inputCell.reasonTextView.textView.rx.text
        .distinctUntilChanged()
        .bind(to: enterDetailReason)
        .disposed(by: disposeBag)

      // MARK: - inputCell output

      reactor?.state.map { $0.numOfText }
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: "")
        .drive(inputCell.reasonTextView.numOfTextLabel.rx.text)
        .disposed(by: disposeBag)

      reactor?.state.map { $0.isErrorLabelShow }
        .distinctUntilChanged()
        .compactMap { $0 }
        .asDriver(onErrorJustReturn: false)
        .drive(onNext: { isLabelShow in
          inputCell.reasonTextView.errorLabel.text = "200자 이상은 ‘호미나라 피드백’을 통해 보내주세요!"

          isLabelShow ?
          (inputCell.reasonTextView.errorLabel.isHidden = false) :
          (inputCell.reasonTextView.errorLabel.isHidden = true)
        })
        .disposed(by: disposeBag)

      reactor?.state.map { $0.isCheckButtonSelected }
        .distinctUntilChanged()
        .compactMap { $0 }
        .asDriver(onErrorJustReturn: false)
        .drive(inputCell.resignCheckButton.rx.isSelected)
        .disposed(by: disposeBag)

      reactor?.state.map { $0.isResignButtonActivated }
        .distinctUntilChanged()
        .compactMap { $0 }
        .asDriver(onErrorJustReturn: false)
        .drive(inputCell.resignButton.rx.isEnabled)
        .disposed(by: disposeBag)

      reactor?.pulse(\.$isResignSuccess)
        .compactMap { $0 }
        .asDriver(onErrorJustReturn: false)
        .drive(onNext: self.transferToSignIn)
        .disposed(by: disposeBag)

      return inputCell
    }
  }
}

extension ResignViewController: ResignInputCellDelegate {

  func didTextViewChange(_ estimatedSize: CGSize,  _ height: CGFloat) {
    if let layout = mainView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.estimatedItemSize = CGSize(
        width: view.frame.width,
        height: estimatedSize.height)
      mainView.collectionView.layoutIfNeeded()
    }

    if textViewHeight < height {
      scrollToBottom()
      textViewHeight = height
    }
  }

  private func scrollToBottom() {
    self.mainView.collectionView.setContentOffset(
      CGPoint(
        x: 0,
        y: self.mainView.collectionView.contentSize.height - self.mainView.collectionView.bounds.height),
      animated: true
    )
  }

  private func transferToSignIn(_ success: Bool) {
    let serviceProvider = ServiceProvider()
    let reactor = SignInReactor(provider: serviceProvider)
    let loginVC = SignInViewController(reactor)

    UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseOut) {
      // 이거 딜레이 걸려면 어케해요
      self.changeRootViewController(to: UINavigationController(rootViewController: loginVC))
    }

  }

}

extension ResignViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
