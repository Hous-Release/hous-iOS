//
//  HousTabBar.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/02.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

import SnapKit

final class HousTabBar: UIStackView {

  var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }

  private lazy var itemViews: [HousTabBarItemView] = [housItemView, todoItemView, profileItemView]

  private let housItemView: HousTabBarItemView = {
    let view =  HousTabBarItemView(item: .hous, index: 0)
    view.clipsToBounds = true
    return view
  }()

  private let todoItemView: HousTabBarItemView = {
    let view = HousTabBarItemView(item: .todo, index: 1)
    view.clipsToBounds = true
    return view
  }()
  private let profileItemView: HousTabBarItemView = {
    let view = HousTabBarItemView(item: .profile, index: 2)
    view.clipsToBounds = true
    return view
  }()

  private let itemTappedSubject = PublishSubject<Int>()
  private let disposeBag = DisposeBag()

  init() {
    super.init(frame: .zero)
    setupViews()
    bind()

    selectItem(index: 0)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {

    axis = .horizontal
    backgroundColor = .gray
    distribution = .fillEqually
    alignment = .center

    layer.cornerRadius = 20

    addArrangedSubview(housItemView)
    addArrangedSubview(todoItemView)
    addArrangedSubview(profileItemView)

    itemViews.forEach { view in
      view.snp.makeConstraints { make in
        make.height.equalTo(52)
      }
    }

  }

  public func selectItem(index: Int) {
    itemViews.forEach { $0.isSelected = $0.index == index }
    itemTappedSubject.onNext(index)
  }

  private func bind() {
    housItemView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.housItemView.animateClick {
          owner.selectItem(index: 0)
          owner.backgroundColor = .gray
        }
      })
      .disposed(by: disposeBag)

    todoItemView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.todoItemView.animateClick {
          owner.selectItem(index: 1)
          owner.backgroundColor = .gray
        }
      })
      .disposed(by: disposeBag)

    profileItemView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.profileItemView.animateClick {
          owner.selectItem(index: 2)
          owner.backgroundColor = .gray
        }
      })
      .disposed(by: disposeBag)
  }
}
