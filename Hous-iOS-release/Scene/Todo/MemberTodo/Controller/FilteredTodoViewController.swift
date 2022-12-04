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

// Todo: FilteredTodoViewController - containerVC / memberTodoViewController & dayOfWeekViewController - contentsVC

enum FilteringType {
  case member, byDay
}

//MARK: - Controller
final class FilteredTodoViewController: UIViewController, ReactorKit.View {

  typealias Reactor = FilteredTodoReactor

  var disposeBag = DisposeBag()

  var viewType: FilteringType = .member {
    didSet {
      var attrString = AttributedString()

      if viewType == .member {
        attrString = AttributedString("요일별 보기")
        removeChildVC(byDayTodoViewController)
        addChildVC(memberTodoViewController)
        navigationBar.title = "멤버별 보기"
      } else if viewType == .byDay {
        attrString = AttributedString("멤버별 보기")
        removeChildVC(memberTodoViewController)
        addChildVC(byDayTodoViewController)
        navigationBar.title = "요일별 보기"
      }
      attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
      attrString.foregroundColor = Colors.g5.color
      navigationBar.rightButton.configuration?.attributedTitle = attrString
    }
  }

  enum Size {
    static let navigationBarHeight = 64
    static let floatingButtonSize = 60
  }

  var navigationBar = NavBarWithBackButtonView(title: "멤버별 보기", rightButtonText: "요일별 보기").then {
    $0.backgroundColor = Colors.g1.color
    $0.rightButton.configuration?.imagePadding = 2
    $0.rightButton.configuration?.imagePlacement = .trailing
    $0.rightButton.configuration?.image = Images.icChange.image
    $0.rightButton.configuration?.baseForegroundColor = Colors.g5.color
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

    let vc = UpdateTodoViewController(reactor)
    navigationController?.pushViewController(vc, animated: true)
  }

  private func addChildVC(_ vc: UIViewController) {
    addChild(vc)
    contentsView.addSubView(vc.view)
    vc.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    vc.didMove(toParent: self)
  }

  private func removeChildVC(_ vc: UIViewController) {
    vc.willMove(toParent: nil)
    vc.view.removeFromSuperview()
    vc.removeFromParent()
  }
}

extension FilteredTodoViewController {
  private func setup() {
    navigationController?.navigationBar.isHidden = true
    navigationBar.delegate = self
    view.backgroundColor = Colors.white.color
    viewType = .member
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
  func backButtonDidTappedWithoutPopUp() {
    print("back")
  }

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
