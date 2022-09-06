//
//  HousTabBarItemView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/02.
//

import UIKit

import SnapKit

final class HousTabBarItemView: UIView {

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    label.textAlignment = .center
    return label
  }()

  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  private let containerView = UIView()


  private let item: HousTabBarItem
  let index: Int

  var isSelected = false {
    didSet {
      animateItems()
    }
  }


  init(item: HousTabBarItem, index: Int) {
    self.item = item
    self.index = index
    super.init(frame: .zero)

    nameLabel.text = item.name
    iconImageView.image = isSelected ? item.selectedIcon : item.icon

    setupViews()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    addSubview(containerView)

    containerView.addSubview(nameLabel)
    containerView.addSubview(iconImageView)

    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    iconImageView.snp.makeConstraints { make in
      make.size.equalTo(20)
      make.top.centerX.equalToSuperview()
    }

    nameLabel.snp.makeConstraints {
      $0.top.equalTo(iconImageView.snp.bottom).offset(2)
      $0.leading.trailing.equalToSuperview()
    }
  }

  private func animateItems() {
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.nameLabel.textColor = self.isSelected ? .blue : .gray
    }

    UIView.transition(
      with: iconImageView,
      duration: 0.4,
      options: .transitionCrossDissolve) { [weak self] in

        guard let self = self else { return }
        self.iconImageView.image = self.isSelected ? self.item.selectedIcon : self.item.icon
      }
  }

  func animateClick(completion: @escaping () -> Void) {
    UIView.animate(withDuration: 0.15) {
      self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    } completion: { _ in
      UIView.animate(withDuration: 0.15) {
        self.transform = CGAffineTransform.identity
      } completion: { _ in completion() }
    }
  }
}
