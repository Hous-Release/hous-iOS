//
//  FilteredTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/15.
//

import UIKit

import RxCocoa
import RxDataSources
import ReactorKit
import AssetKit

// Todo: FilteredTodoViewController - containerVC / memberTodoViewController & dayOfWeekViewController - contentsVC

enum FilteringType {
  case member, byDay
}

// MARK: - Controller
final class FilteredTodoViewController: UIViewController, ReactorKit.View {

  typealias Reactor = FilteredTodoReactor
  var disposeBag = DisposeBag()

  enum Size {
    static let navigationBarHeight = 64
    static let floatingButtonSize = 60
  }

  var viewType: FilteringType = .byDay {
    didSet {

      if viewType == .member {

        navigationBar.title = "멤버별 보기"
        navigationBar.rightButtonImage = Images.btnDaily.image

        removeChildVC(byDayTodoViewController)
        addChildVC(memberTodoViewController)

      } else if viewType == .byDay {

        navigationBar.title = "요일별 보기"
        navigationBar.rightButtonImage = Images.btnMember.image

        removeChildVC(memberTodoViewController)
        addChildVC(byDayTodoViewController)
      }
    }
  }

  var navigationBar = NavBarWithBackButtonView(title: "요일별 보기").then {
    $0.backgroundColor = Colors.g1.color
    $0.rightButtonImage = Images.btnMember.image
  }
  private var contentsView = UIView()

  private var floatingAddButton = UIButton().then {
    $0.setImage(Images.btnAddFloating.image, for: .normal)
  }

  let serviceProvider = ServiceProvider()

  lazy var memberTodoViewReactor = MemberTodoViewReactor(provider: serviceProvider)
  lazy var memberTodoViewController = MemberTodoViewController(memberTodoViewReactor)

  lazy var byDayTodoViewReactor = ByDayTodoViewReactor(provider: serviceProvider)
  lazy var byDayTodoViewController = ByDayTodoViewController(byDayTodoViewReactor)

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    render()
    self.reactor = Reactor(provider: self.serviceProvider)

  }

  func bind(reactor: Reactor) {
    bindAction(reactor)
    bindState(reactor)
    bindNavRightButton()
  }
}

// MARK: Bind Action

extension FilteredTodoViewController {
  func bindAction(_ reactor: Reactor) {
    bindViewWillAppearAction(reactor)
    bindDidTapPlusButtonAction(reactor)
  }

  func bindViewWillAppearAction(_ reactor: Reactor) {
    rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
      .map { _ in Reactor.Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  func bindDidTapPlusButtonAction(_ reactor: Reactor) {
    floatingAddButton.rx.tap
      .map { _ in Reactor.Action.didTapPlusButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

// MARK: - Bind State

extension FilteredTodoViewController {

  func bindState(_ reactor: Reactor) {
    bindTrasnferState(reactor)
  }

  func bindTrasnferState(_ reactor: Reactor) {
    reactor.pulse(\.$isTransfer)
      .skip(1)
      .map { reactor.currentState.homies }
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: self.transferToAddTodoViewController)
      .disposed(by: disposeBag)
  }

  private func bindNavRightButton() {
    navigationBar.rightButton.rx.tap
      .subscribe { [weak self] _ in
        self?.viewType == .member ? (self?.viewType = .byDay) : (self?.viewType = .member)
      }
      .disposed(by: disposeBag)
  }
}

extension FilteredTodoViewController {

  private func transferToAddTodoViewController(_ homies: [UpdateTodoHomieModel]) {

    byDayTodoViewReactor.action.onNext(.initial)
    memberTodoViewReactor.action.onNext(.initial)

    let state = UpdateTodoReactor.State(
      todoHomies: homies
    )
    let provider = ServiceProvider()
    let reactor = UpdateTodoReactor(
      provider: provider,
      state: state
    )

    let viewController = UpdateTodoViewController(reactor)
    navigationController?.pushViewController(viewController, animated: true)
  }

  private func addChildVC(_ viewController: UIViewController) {
    addChild(viewController)
    contentsView.addSubView(viewController.view)
    viewController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    viewController.didMove(toParent: self)
  }

  private func removeChildVC(_ viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
}

extension FilteredTodoViewController {
  private func setup() {
    navigationController?.navigationBar.isHidden = true
    navigationBar.delegate = self
    view.backgroundColor = Colors.white.color
    viewType = .byDay
  }

  private func render() {
    view.addSubViews([navigationBar, contentsView, floatingAddButton])

    navigationBar.snp.makeConstraints { make in
      make.height.equalTo(Size.navigationBarHeight)
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }

    contentsView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    floatingAddButton.snp.makeConstraints { make in
      make.bottom.trailing.equalToSuperview().inset(40)
      make.size.equalTo(Size.floatingButtonSize)
    }
  }
}

extension FilteredTodoViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
